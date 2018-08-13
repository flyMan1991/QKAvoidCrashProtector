//
//  NSString+QKCrash.h
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/9.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Can avoid crash method
 *
 *  1. - (unichar)characterAtIndex:(NSUInteger)index
 *  2. - (NSString *)substringFromIndex:(NSUInteger)from
 *  3. - (NSString *)substringToIndex:(NSUInteger)to {
 *  4. - (NSString *)substringWithRange:(NSRange)range {
 *  5. - (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement
 *  6. - (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange
 *  7. - (NSString *)stringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement
 *
 
 stringByReplacingOccurrencesOfString:withString: 实际调用的是stringByReplacingOccurrencesOfString:withString:options:range:

 
 */

@interface NSString (QKCrash)

+ (void)qk_enableStringProtector;


@end
