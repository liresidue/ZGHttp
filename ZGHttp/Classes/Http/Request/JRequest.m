//
//  JRequest.m
//  DailyDemo
//
//  Created by Hitter on 2019/4/9.
//  Copyright © 2019 Hitter. All rights reserved.
//

#import "JRequest.h"
#import "JRequestConfig.h"
#import "AFNetworking.h"

@implementation JRequest {
    // 单例
    AFHTTPSessionManager *_manager;
    // 缓存Request
    NSMutableDictionary *_httpTasks;
    
    // 可定制参数
    NSString *_url;
    NSString *_cookie;
    NSTimeInterval _timeout;
    NSDictionary *_dictParam;
    JRequestMethod _requestMethod;
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
    req->_requestMethod = JRequestMethodPost;
    req->_url           = url;
    req->_timeout       = 15.f;
    req->_cookie        = @"";
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
    switch (_requestMethod) {
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

- (JRequest<JRequestProtocol> *(^)(JResponseSerializerType))responseSerializer {
    return ^id(JResponseSerializerType __responseSerializerType) {
        self->_responseSerializerType = __responseSerializerType;
        return self;
    };
}

- (JRequest<JRequestProtocol> *(^)(JRequestSerializerType))requestSerializer {
    return ^id(JRequestSerializerType __requestSerializerType) {
        self->_requestSerializerType = __requestSerializerType;
        return self;
    };
}

- (JRequest<JRequestProtocol> *(^)(NSTimeInterval))timeout {
    return ^id(NSTimeInterval __timeout) {
        self->_timeout = __timeout;
        return self;
    };
}

- (JRequest<JRequestProtocol> *(^)(JRequestMethod))method {
    return ^id(JRequestMethod __requestMethod) {
        self->_requestMethod = __requestMethod;
        return self;
    };
}

- (JRequest<JRequestProtocol> *(^)(NSDictionary *))dictParam {
    return ^id(NSDictionary *__dictParam) {
        self->_dictParam = __dictParam;
        return self;
    };
}

- (JRequest<JRequestProtocol> *(^)(JRequestCompletionBlock))completionBlock {
    return ^id(JRequestCompletionBlock __completionBlock) {
        self->_completionBlock = __completionBlock;
        return self;
    };
}

- (JRequest<JRequestProtocol> *(^)(JRequestProgressBlock))progressBlock {
    return ^id(JRequestProgressBlock __progressBlock) {
        self->_progressBlock = __progressBlock;
        return self;
    };
}

- (JRequest<JRequestProtocol> *(^)(JRequestFailureBlock))failureBlock {
    return ^id(JRequestFailureBlock __failureBlock) {
        self->_failureBlock = __failureBlock;
        return self;
    };
}

- (JRequest<JRequestProtocol> *(^)(NSString *))cookie {
    return ^id(NSString *__cookie) {
        self->_cookie = __cookie;
        return self;
    };
}

- (id (^)(void))start {
    return ^id() {
        // 设置请求数据格式
        switch (self->_requestSerializerType) {
            case JRequestSerializerTypeJSON: {
                self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
            } break;
            case JRequestSerializerTypeHTTP: {
                self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            } break;
        }
        [self.manager.requestSerializer setValue:[JRequestConfig config].userAgent forHTTPHeaderField:@"User-Agent"];
        
        // 设置响应数据格式
        switch (self->_responseSerializerType) {
            case JResponseSerializerTypeJSON: {
                AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
                self.manager.responseSerializer = responseSerializer;
            } break;
            case JResponseSerializerTypeHTTP: {
                AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
                self.manager.responseSerializer = responseSerializer;
            } break;
            case JResponseSerializerTypeXMLParser: {
                AFXMLParserResponseSerializer *responseSerializer = [AFXMLParserResponseSerializer serializer];
                self.manager.responseSerializer = responseSerializer;
            } break;
        }
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json" ,@"text/javascript", @"text/plain", nil];
        
        // 设置cookie
        if (self->_cookie) {
            [self.manager.requestSerializer setValue:self->_cookie forHTTPHeaderField:@"Cookie"];
        }
        
        // 设置超时时间
        if (self->_timeout > 0) {
            self.manager.requestSerializer.timeoutInterval = self->_timeout;
        }
        
        // 设置参数
        if (!self->_dictParam) {
            self->_dictParam = [NSDictionary dictionary];
        }
        if (![self->_dictParam isKindOfClass:[NSDictionary class]]) {
            NSLog(@"参数格式错误 - %@ 内容为 - \n%@", NSStringFromClass([self->_dictParam class]), self->_dictParam);
            return nil;
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
        // 创建单例
        manager = [AFHTTPSessionManager manager];
        manager.securityPolicy = [JRequestConfig config].securityPolicy;
        self->_httpTasks = [NSMutableDictionary dictionary];
    });
    return manager;
}

@end
