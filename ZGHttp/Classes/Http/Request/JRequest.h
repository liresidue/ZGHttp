//
//  JRequest.h
//  DailyDemo
//
//  Created by Hitter on 2019/4/9.
//  Copyright © 2019 Hitter. All rights reserved.
//  

#import <UIKit/UIKit.h>
#import "JHeader.h"

@class JRequest;

@protocol JRequestProtocol <NSObject>

+ (JRequest *)requestWithUrl:(NSString *)url;

/**
 * 设置请求类型
 */
@property (copy, nonatomic, readonly) JRequest<JRequestProtocol>* (^method)(JRequestMethod method);

/**
 * 设置请求类型
 */
@property (copy, nonatomic, readonly) JRequest<JRequestProtocol>* (^requestSerializer)(JRequestSerializerType requestSerializerType);

/**
 * 设置回调类型
 */
@property (copy, nonatomic, readonly) JRequest<JRequestProtocol>* (^responseSerializer)(JResponseSerializerType responseSerializerType);

/**
 * 设置超时时间 默认15s
 */
@property (copy, nonatomic, readonly) JRequest<JRequestProtocol>* (^timeout)(NSTimeInterval timeout);

/**
 * 模型参数
 */
@property (copy, nonatomic, readonly) JRequest<JRequestProtocol> *(^dictParam)(NSDictionary *dictParam);

/**
 * 成功回调
 */
@property (copy, nonatomic, readonly) JRequest<JRequestProtocol> *(^completionBlock)(JRequestCompletionBlock completed);

/**
 * 请求进度回调
 */
@property (copy, nonatomic, readonly) JRequest<JRequestProtocol> *(^progressBlock)(JRequestProgressBlock progressBlock);

/**
 * 失败回调
 */
@property (copy, nonatomic, readonly) JRequest<JRequestProtocol> *(^failureBlock)(JRequestFailureBlock failure);

/**
 * 开始请求
 */
@property (copy, nonatomic, readonly) id (^start)(void);

@end

@interface JRequest : NSObject <JRequestProtocol>

@end
