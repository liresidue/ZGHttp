//
//  JUpload.h
//  Pods-ZGHttp_Example
//
//  Created by hitter on 2020/3/6.
//

#import "JHeader.h"

@class JUpload;

NS_ASSUME_NONNULL_BEGIN
@protocol JUploadProtocol <NSObject>


//+ (JUpload *)requestWithUrl:(NSString *)url;
//
///**
// * 设置上传图片的fileName
// */
//@property (copy, nonatomic, readonly) JUpload* (^fileName)(NSString *fileName);
//
///**
// * 上传数据
// */
//@property (copy, nonatomic, readonly) JUpload<JUploadProtocol> *(^imageFiles)(NSArray *imageFiles);
//
///**
// * 成功回调
// */
//@property (copy, nonatomic, readonly) JUpload<JUploadProtocol> *(^completionBlock)(JRequestCompletionBlock completed);
//
///**
// * 失败回调
// */
//@property (copy, nonatomic, readonly) JUpload<JUploadProtocol> *(^failureBlock)(JRequestFailureBlock failure);
//
///**
// * 开始请求
// */
//@property (copy, nonatomic, readonly) id (^start)(void);

@end

@interface JUpload : NSObject


@end

NS_ASSUME_NONNULL_END
