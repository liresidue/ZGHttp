//
//  JRequestResult.h
//  AFNetworking
//
//  Created by hitter on 2020/3/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JRequestResult : NSObject

@property (copy, nonatomic) NSString *msg;

@property (assign, nonatomic) NSInteger code;

@property (strong, nonatomic) id data;

@end

NS_ASSUME_NONNULL_END
