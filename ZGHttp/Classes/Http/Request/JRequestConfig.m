//
//  JRequestConfig.m
//  AFNetworking
//
//  Created by hitter on 2020/3/9.
//

#import "JRequestConfig.h"

@implementation JRequestConfig

+ (JRequestConfig *)config {
    static JRequestConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[JRequestConfig alloc] init];
    });
    return config;
}

#pragma mark - <Getter>

- (AFSecurityPolicy *)securityPolicy {
    if (!_securityPolicy) {
        // 设置安全策略
        _securityPolicy = [AFSecurityPolicy defaultPolicy];
        _securityPolicy.validatesDomainName = NO;
        _securityPolicy.allowInvalidCertificates = YES;
    }
    return _securityPolicy;
}

@end
