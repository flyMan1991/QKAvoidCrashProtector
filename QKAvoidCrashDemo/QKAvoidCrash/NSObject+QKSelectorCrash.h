//
//  NSObject+QKSelectorCrash.h
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/8.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QKUnrecognizedSelectorSolveObject:NSObject

@property (nonatomic,weak) NSObject * objc;

@end

@interface NSObject (QKSelectorCrash)


+ (void)setupNoneSelClassStringsArr:(NSArray<NSString *> *)classStrings;

+ (void)setupNoneSelClassStringPrefixsArr:(NSArray<NSString *> *)classStringPrefixs;
+ (void)qk_enableSelectorProtector;



@end
