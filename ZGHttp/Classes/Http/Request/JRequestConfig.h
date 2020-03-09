//
//  JRequestConfig.h
//  AFNetworking
//
//  Created by hitter on 2020/3/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JRequestConfig : NSObject

+ (JRequestConfig *)config;

@property (copy, nonatomic) NSString *userAgent; // 设置UA

@property (strong, nonatomic) id securityPolicy;

@end

NS_ASSUME_NONNULL_END
