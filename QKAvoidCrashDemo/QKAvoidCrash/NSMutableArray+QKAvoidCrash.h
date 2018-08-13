//
//  NSMutableArray+QKAvoidCrash.h
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/7.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  Can avoid crash method
 *
 *  1. - (id)objectAtIndex:(NSUInteger)index
 *  2. - (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
 *  3. - (void)removeObjectAtIndex:(NSUInteger)index
 *  4. - (void)insertObject:(id)anObject atIndex:(NSUInteger)index
 *  5. - (void)getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range
 *  6.
 */

@interface NSMutableArray (QKAvoidCrash)

+ (void)qk_enableMutableArrayProtector;

@end
