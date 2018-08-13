//
//  NSObject+QKNotificationCrash.h
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/9.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 当一个对象添加notification之后,如果dealloc的时候,仍然持有notification,就会出现notification类型的crash.
 iOS9之后专门针对这种情况做了处理,即使没有移除observer,notification,crash也不会再产生了
 */

@interface NSObject (QKNotificationCrash)

+ (void)qk_enableNotificationProtector;

@end
