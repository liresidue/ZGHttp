//
//  JRequest.m
//  DailyDemo
//
//  Created by Hitter on 2019/4/9.
//  Copyright © 2019 Hitter. All rights reserved.
//

#import "JRequest.h"

@implementation JRequest {
    // 单例
    AFHTTPSessionManager *_manager;
    // 缓存Request
    NSMutableDictionary *_httpTasks;
    
    // 可定制参数
    NSString *_url;
    NSString *_cookie;
    NSString *_baseUrl;
    NSTimeInterval _timeout;
    NSDictionary *_dictParam;
    JRequestMethod _requestMode;
    JRequestSerializerType _requestSerializerType;
    JResponseSerializerType _responseSerializerType;
    
    // 回调
    JRequestFailureBlock _failureBlock;
    JRequestProgressBlock _progressBlock;
    JRequestCompletionBlock _completionBlock;
}

#pragma mark - <Initialization>

+ (JRequest *)requestWithUrl:(NSString *)url {
    JRequest *req = [[JRequest alloc] init];
    req->_requestMode = JRequestMethodPost;
    req->_timeout     = 15.f;
    req->_baseUrl     = @"";
    req->_cookie      = @"";
    return req;
}

#pragma mark - <Systems>

- (instancetype)init {
    if (self = [super init]) {
        [self manager];
    }
    return self;
}

#pragma mark - <Post && Get>

- (void)startRequest {
    // 开始请求
    /**
     * 1、请求前缓存请求
     * 2、请后释放请求
     * 3、重复请求是否取消
     * 4、
     */
    
    
    switch (_requestMode) {
        case JRequestMethodPost: {
            [self.manager POST:_url
                    parameters:_dictParam
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                           if (self->_progressBlock) {
                              self->_progressBlock(uploadProgress);
                           }
                       }
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           if (self->_completionBlock) {
                               self->_completionBlock(task, responseObject);
                           }
                       }
                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           if (self->_failureBlock) {
                               self->_failureBlock(error);
                           }
                       }];
        } break;
        case JRequestMethodGet: {
            [self.manager GET:_url
                   parameters:_dictParam
                     progress:^(NSProgress * _Nonnull downloadProgress) {
                          if (self->_progressBlock) {
                              self->_progressBlock(downloadProgress);
                          }
                      }
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          if (self->_completionBlock) {
                              self->_completionBlock(task, responseObject);
                          }
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          if (self->_failureBlock) {
                              self->_failureBlock(error);
                          }
                      }];
        } break;
        default: break;
    }
    
}

#pragma mark - <Protocol>

- (JRequest<JRequestProtocol> *(^)(NSDictionary *))dictParam {
    return ^id(NSDictionary *dictParam) {
        self->_dictParam = dictParam;
        return self;
    };
}

- (JRequest<JRequestProtocol> *(^)(JRequestCompletionBlock))completionBlock {
    return ^id(JRequestCompletionBlock completionBlock) {
        self->_completionBlock = completionBlock;
        return self;
    };
}

- (JRequest<JRequestProtocol> *(^)(JRequestFailureBlock))failureBlock {
    return ^id(JRequestFailureBlock failureBlock) {
        self->_failureBlock = failureBlock;
        return self;
    };
}

- (JRequest *(^)(NSString *))cookie {
    return ^id(NSString *cookie) {
        if (cookie) self->_cookie = cookie;
        return self;
    };
}

- (JRequest *(^)(NSString *))autoBaseUrl {
    return ^id(NSString *autoBaseUrl) {
        self->_baseUrl = autoBaseUrl;
        return self;
    };
}

- (id (^)(void))start {
    return ^id() {
        
//        if (self->_isFromData) { // 如果是表单提交
//            self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        } else {
//            self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        }
        // 设置请求requestSerializer
        NSString *userAgent = [NSString stringWithFormat:@"ZgApp/%@ (%@; iOS %@; Scale/%0.2f ) Width/%.0lf Height/%.0lf", [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale], [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height];
        [self.manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
        self.manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
        
        if (self->_cookie) {
            [self.manager.requestSerializer setValue:self->_cookie forHTTPHeaderField:@"Cookie"];
        }
        
//        if (self->_isResponJson) {
//            AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
//            responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json" ,@"text/javascript", @"text/plain", nil];
//            self.manager.responseSerializer = responseSerializer;
//        }
        
        if (self->_timeout > 0) {
            self.manager.requestSerializer.timeoutInterval = self->_timeout;
        }
        
        if (!self->_dictParam) {
            self->_dictParam = [NSDictionary dictionary];
        }
        
        if (![self->_dictParam isKindOfClass:[NSDictionary class]]) {
            NSLog(@"参数格式错误 - %@ 内容为 - \n%@", NSStringFromClass([self->_dictParam class]), self->_dictParam);
            return nil;
        }
        
        if (self->_baseUrl) {
            self->_url = [NSString stringWithFormat:@"%@%@", self->_baseUrl, self->_url];
        }
        
        [self startRequest];
        
        return nil;
    };
}

- (JRequest *(^)(NSTimeInterval))timeout {
    return ^id(NSTimeInterval timeout) {
        self->_timeout = timeout;
        return self;
    };
}

#pragma mark - <Getter>

- (AFHTTPSessionManager *)manager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 设置安全策略
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.validatesDomainName = NO;
        securityPolicy.allowInvalidCertificates = YES;
        
        // 创建单例
        manager = [AFHTTPSessionManager manager];
        manager.securityPolicy = securityPolicy;
        self->_httpTasks = [NSMutableDictionary dictionary];
    });
    return manager;
}

@end
