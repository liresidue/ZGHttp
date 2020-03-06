//
//  JHeader.h
//  Pods
//
//  Created by hitter on 2020/3/6.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

typedef void (^JRequestFailureBlock)(NSError *err); // 请求失败返回的block
typedef void (^JRequestProgressBlock)(NSProgress *progress); // 请求进度返回
typedef void (^JRequestCompletionBlock)(NSURLSessionDataTask *task, id result); // 请求成功返回的block

// request method
typedef NS_ENUM(NSUInteger, JRequestMethod) {
    JRequestMethodPost = 0,
    JRequestMethodGet,
};

// request serializer type
typedef NS_ENUM(NSUInteger, JRequestSerializerType) {
    JRequestSerializerTypeJSON = 0,
    JRequestSerializerTypeHTTP,
};

// response serializer type
typedef NS_ENUM(NSInteger, JResponseSerializerType) {
    JResponseSerializerTypeHTTP,
    JResponseSerializerTypeJSON,
    JResponseSerializerTypeXMLParser,
};
