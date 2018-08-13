//
//  QKCrashLog.m
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/7.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import "QKCrashLog.h"

static const NSString *QKCrashSeparatorWithFlag = @"------------ QKCrashProtector ----------------";

@implementation QKCrashLog

- (void)getCrashMsg{
    NSLog(@"CrashProtector:  %@",_crashMsg);
}

+ (void)printCrashMsg:(NSString *)crashMsg {
    NSLog(@"\n*****************\n\nCrashProtector:  %@\n\n*****************\n",crashMsg);
}
+ (void)qk_noteErrorWithException:(NSException *)exception attachedTODO:(NSString *)todo {
    // 堆栈数据
    NSArray * callStackSybolArr = [NSThread callStackSymbols];
    NSString *mainCallStackSymbolMsg = @"";
    NSString *crashClassInfo = @"";
    //获取在哪个类的哪个方法中实例化的数组  字符串格式 -[类名 方法名]  或者 +[类名 方法名]
    if (callStackSybolArr.count >= 3) {
        mainCallStackSymbolMsg = [self _getMainCallStackSymbolMessageWithCallStackSymbolStr:callStackSybolArr[2]];
    }
    if (mainCallStackSymbolMsg.length <= 0) {
        mainCallStackSymbolMsg = @"崩溃方法定位失败,请您查看函数调用栈来排查错误原因";
    }
    if (crashClassInfo.length <= 0) {
        crashClassInfo = @"崩溃类信息定位失败";
    }
    NSString *crashType = [NSString stringWithFormat:@">>>>>>>>>>>> [Crash Type]: %@",exception.name];
    NSString *errorReason = [NSString stringWithFormat:@">>>>>>>>>>>> [Crash Reason]: %@",exception.reason];;
    NSString *errorPlace = [NSString stringWithFormat:@">>>>>>>>>>>> [Error Place]: %@",mainCallStackSymbolMsg];
    NSString *crashProtector = [NSString stringWithFormat:@">>>>>>>>>>>> [Attached TODO]: %@",todo];
//    NSString *crashClassMethodInfo = [NSString stringWithFormat:@">>>>>>>>>>>> 崩溃方法位置为: %@",errorPlace];
    NSString *logErrorMessage = [NSString stringWithFormat:@"\n\n%@\n\n%@\n%@\n%@\n%@\n%@\n",QKCrashSeparatorWithFlag, crashType, errorReason, errorPlace, crashProtector, exception.callStackSymbols];
    NSLog(@"%@", logErrorMessage);
}
/**
 *  获取堆栈主要崩溃精简化的信息<根据正则表达式匹配出来>
 *
 *  @param callStackSymbolStr 堆栈主要崩溃信息
 *
 *  @return 堆栈主要崩溃精简化的信息
 */
+ (NSString *)_getMainCallStackSymbolMessageWithCallStackSymbolStr:(NSString *)callStackSymbolStr  {
    //mainCallStackSymbolMsg的格式为   +[类名 方法名]  或者 -[类名 方法名]
    __block NSString * mainCallStackSymbolMsg = @"";
    //匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    [regularExp enumerateMatchesInString:callStackSymbolStr options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbolStr.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result) {
            mainCallStackSymbolMsg = [callStackSymbolStr substringWithRange:result.range];
            *stop = YES;
        }
    }];
    return mainCallStackSymbolMsg;
}
@end
