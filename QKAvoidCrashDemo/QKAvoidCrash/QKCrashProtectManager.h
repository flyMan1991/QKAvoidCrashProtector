//
//  QKCrashProtectManager.h
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/9.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
  实际开发时关闭该组件,以便及时发现bug,只有上线时才开启crash防护
  改组件会占用一定内存,正常使用不影响性能
 */

typedef NS_ENUM(NSUInteger,QKCrashProtectorStyle) {
    QKCrashProtectorStyleNone = 0,  // 无防护
    QKCrashProtectorStyleAll,       // 所有
    QKCrashProtectorStyleUnrecognizedSelector,  // 未识别方法
    QKCrashProtectorStyleKVO,       //KVO
    QKCrashProtectorStyleNotification,  // 通知
    QKCrashProtectorStyleTimer,         // Timer
    QKCrashProtectorStyleString,        // String
    QKCrashProtectorStyleArr,           // Arr,
    QKCrashProtectorStyleDictionary,    // Dictionary
};

@interface QKCrashProtectManager : NSObject



/**
 *
 * 启动所有组件
 **/
+ (void)makeAllEffective;


/**
 *
 * @param style 启动组件的类型
 **/
+ (void)startServiceWithProtectorStyle:(QKCrashProtectorStyle)style;




@end
