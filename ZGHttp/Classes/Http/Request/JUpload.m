//
//  JUpload.m
//  Pods-ZGHttp_Example
//
//  Created by hitter on 2020/3/6.
//

#import "JUpload.h"
#import "JRequestConfig.h"
#import "AFNetworking.h"

@implementation JUpload {
    // 单例
    AFHTTPSessionManager *_manager;
    
    // 定制参数
    NSString *_cookie;
    NSString *_url;
    NSString *_fileName;
    NSMutableArray *_imageFileArray;
    
    // 回调
    JRequestFailureBlock _failureBlock;
    JRequestProgressBlock _progressBlock;
    JRequestCompletionBlock _completionBlock;
}

#pragma mark - <Initialization>

+ (JUpload *)uploadWithUrl:(NSString *)url {
    JUpload *req = [[JUpload alloc] init];
    req->_url    = url;
    req->_cookie = @"";
    return req;
}

#pragma mark - <Request>

- (void)startRequest {
    if (_imageFileArray) { // 图片上传
        [self.manager POST:_url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSInteger count = 0;
            for (id file in self->_imageFileArray) {
                UIImage *image;
                if ([file isKindOfClass:[UIImage class]]) {
                    image = file;
                } else if ([file isKindOfClass:[NSURL class]]) {
                    NSData *data = [NSData dataWithContentsOfURL:file];
                    image = [UIImage imageWithData:data];
                }
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                NSString *locationFileName = [NSString stringWithFormat:@"%@.jpg", dateString];
                // 压缩图片尺寸(1200 * iph)
                CGSize imageSize;
                if (image.size.width >= 1200) {
                    imageSize = CGSizeMake(1200, image.size.height / image.size.width * 1200);
                } else {
                    imageSize = CGSizeMake(image.size.width, image.size.height);
                }
                UIGraphicsBeginImageContext(imageSize);
                [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                // 压缩图片质量
                
                NSData *imageData = UIImageJPEGRepresentation(resultImage, 1);
                [formData appendPartWithFileData:imageData
                                            name:self->_fileName ? self->_fileName : @""
                                        fileName:locationFileName
                                        mimeType:@"image/jpeg"];
                count ++;
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            if (self->_progressBlock) {
                self->_progressBlock(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (self->_completionBlock) {
                self->_completionBlock(task, responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (self->_failureBlock) {
                self->_failureBlock(error);
            }
        }];
    } else {
        NSLog(@"_imageFileArray - %@ count - %lu", _imageFileArray, (unsigned long)_imageFileArray.count);
    }
}

#pragma mark - <Protocol>

- (JUpload<JUploadProtocol> *(^)(JRequestCompletionBlock))completionBlock {
    return ^id(JRequestCompletionBlock __completionBlock) {
        self->_completionBlock = __completionBlock;
        return self;
    };
}

- (JUpload<JUploadProtocol> *(^)(JRequestProgressBlock))progressBlock {
    return ^id(JRequestProgressBlock __progressBlock) {
        self->_progressBlock = __progressBlock;
        return self;
    };
}

- (JUpload<JUploadProtocol> *(^)(JRequestFailureBlock))failureBlock {
    return ^id(JRequestFailureBlock __failureBlock) {
        self->_failureBlock = __failureBlock;
        return self;
    };
}

- (JUpload<JUploadProtocol> *(^)(NSString *))cookie {
    return ^id(NSString *__cookie) {
        self->_cookie = __cookie;
        return self;
    };
}

- (id (^)(void))start {
    return ^id() {
        // 设置请求数据格式
        [self.manager.requestSerializer setValue:[JRequestConfig config].userAgent forHTTPHeaderField:@"User-Agent"];
        
        // 设置cookie
        if (self->_cookie) {
            [self.manager.requestSerializer setValue:self->_cookie forHTTPHeaderField:@"Cookie"];
        }
    
        // 开始请求
        [self startRequest];
        
        return nil;
    };
}

#pragma mark - <Singleton>

- (AFHTTPSessionManager *)manager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.securityPolicy = [JRequestConfig config].securityPolicy;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    return manager;
}

@end
