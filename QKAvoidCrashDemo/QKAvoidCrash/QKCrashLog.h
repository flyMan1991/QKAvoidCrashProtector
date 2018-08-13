//
//  QKCrashLog.h
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/7.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import <Foundation/Foundation.h>

//user can ignore below define
static NSString * _Nullable QKCrashDefaultReturnNil = @"This framework default is to return nil to avoid crash.";
static NSString * _Nullable QKCrashDefaultReturnIgnore  = @"This framework default is to ignore this operation to avoid crash.";

@interface QKCrashLog : NSObject

@property (nonatomic,copy) NSString * _Nullable crashMsg;
// 获取崩溃信息
- (void)getCrashMsg;
// 打印崩溃信息
+ (void)printCrashMsg:(NSString *_Nullable)crashMsg;
// 错误信息
+ (void)qk_noteErrorWithException:(NSException *_Nonnull)exception attachedTODO:(NSString *_Nullable)todo;

@end
