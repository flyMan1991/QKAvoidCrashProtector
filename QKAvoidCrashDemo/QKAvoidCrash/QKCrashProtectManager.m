//
//  QKCrashProtectManager.m
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/9.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import "QKCrashProtectManager.h"
#import "QKCrashProtectorHeader.h"


@implementation QKCrashProtectManager

+ (void)makeAllEffective {
    [self _startAllComponents];
}

+ (void)startServiceWithProtectorStyle:(QKCrashProtectorStyle)style {
    switch (style) {
        case QKCrashProtectorStyleNone:
            
            break;
        case QKCrashProtectorStyleAll:
            [self _startAllComponents];
            break;
        case QKCrashProtectorStyleUnrecognizedSelector:
            [NSObject qk_enableSelectorProtector];
            break;
        case QKCrashProtectorStyleKVO:
            [NSObject qk_enableKVOProtector];
            break;
        case QKCrashProtectorStyleNotification:
            [NSObject qk_enableNotificationProtector];
            break;
        case QKCrashProtectorStyleTimer:
            [NSTimer qk_enableTimerProtector];
            break;
        case QKCrashProtectorStyleString:
        {
            [NSString qk_enableStringProtector];
            [NSMutableString qk_enableMutableStringProtector];
        }
            break;
        case QKCrashProtectorStyleArr:
        {
            [NSArray qk_enableArrayProtector];
            [NSMutableArray qk_enableMutableArrayProtector];
        }
            break;
        case QKCrashProtectorStyleDictionary:
        {
            [NSDictionary qk_enableDictionaryProtector];
            [NSMutableDictionary qk_enableMutableDictionaryCrashProtector];
        }
            break;
        default:
            break;
    }
}

+ (void)_startAllComponents {
    [NSObject qk_enableSelectorProtector];
//    [NSObject qk_enableNotificationProtector]; // 可能会有性能问题，dealloc里面加了判断，系统的每个对象dealloc时都会调用
    [NSObject qk_enableKVOProtector];
    
    [NSArray qk_enableArrayProtector];
    [NSMutableArray qk_enableMutableArrayProtector];
    
    
    [NSDictionary qk_enableDictionaryProtector];
    [NSMutableDictionary qk_enableMutableDictionaryCrashProtector];
    
    [NSString qk_enableStringProtector];
    [NSMutableString qk_enableMutableStringProtector];
    
    
    [NSTimer qk_enableTimerProtector];
}
@end
