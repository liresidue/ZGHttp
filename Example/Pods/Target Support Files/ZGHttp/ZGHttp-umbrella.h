#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "JHeader.h"
#import "JRequest.h"
#import "JRequestConfig.h"
#import "JRequestResult.h"
#import "JUpload.h"
#import "ZGHttp.h"

FOUNDATION_EXPORT double ZGHttpVersionNumber;
FOUNDATION_EXPORT const unsigned char ZGHttpVersionString[];

