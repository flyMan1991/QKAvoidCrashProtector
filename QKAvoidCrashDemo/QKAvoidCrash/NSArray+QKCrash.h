//
//  NSArray+QKCrash.h
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/8.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  Can avoid crash method
 *
 *  1. NSArray的快速创建方式 NSArray *array = @[@"chenfanfang", @"AvoidCrash"];  //这种创建方式其实调用的是2中的方法
 *  2. +(instancetype)arrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt
 *  3. - (id)objectAtIndex:(NSUInteger)index
 *  4. - (void)getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range
 */


@interface NSArray (QKCrash)

+ (void)qk_enableArrayProtector;

@end
