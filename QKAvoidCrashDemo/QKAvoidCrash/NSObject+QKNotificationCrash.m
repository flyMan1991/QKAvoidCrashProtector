//
//  NSObject+QKNotificationCrash.m
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/9.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import "NSObject+QKNotificationCrash.h"
#import "NSObject+QKSwizzle.h"

static const char *isNSNotification = "isNSNotification";

@implementation NSObject (QKNotificationCrash)
+ (void)qk_enableNotificationProtector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSObject * objc = [[NSObject alloc] init];
        [objc qk_instanceSwizzleMethod:@selector(addObserver:selector:name:object:) replaceMethod:@selector(qk_addObserver:selector:name:object:)];
        // 在ARC环境下不能显示 @selector dealloc
        [objc qk_instanceSwizzleMethod:NSSelectorFromString(@"dealloc") replaceMethod:NSSelectorFromString(@"qk_dealloc")];
    });
}

- (void)qk_addObserver:(id)observer selector:(SEL)aSelector name:(nullable NSNotificationName)aName object:(nullable id)anObject {
    [observer setIsNSNotification:YES];
    [self qk_addObserver:observer selector:aSelector name:aName object:anObject];
}
- (void)setIsNSNotification:(BOOL)yesOrNo {
    objc_setAssociatedObject(self, isNSNotification, @(yesOrNo), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)IsNSNotification {
    NSNumber * number = objc_getAssociatedObject(self, isNSNotification);
    return [number boolValue];
}

/*
 如果一个对象从来没有添加过通知，那就不要remove操作
 */
- (void)qk_dealloc {
    if ([self IsNSNotification]) {
        NSLog(@"CrashProtector: %@ is dealloc，but NSNotificationCenter Also exsit",self);
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    [self qk_dealloc];
}
@end
