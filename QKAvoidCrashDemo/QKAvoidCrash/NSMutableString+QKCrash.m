//
//  NSMutableString+QKCrash.m
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/9.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import "NSMutableString+QKCrash.h"
#import "NSObject+QKSwizzle.h"


@implementation NSMutableString (QKCrash)
+ (void)qk_enableMutableStringProtector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSCFString = NSClassFromString(@"__NSCFString");
        //replaceCharactersInRange
        [self qk_instanceSwizzleMethodWithClass:__NSCFString orginalMethod:@selector(replaceCharactersInRange:withString:) replaceMethod:@selector(qk_replaceCharactersInRange:withString:)];
        
        //insertString:atIndex:
        [self qk_instanceSwizzleMethodWithClass:__NSCFString orginalMethod:@selector(insertString:atIndex:) replaceMethod:@selector(qk_insertString:atIndex:)];
        
        //deleteCharactersInRange
        [self qk_instanceSwizzleMethodWithClass:__NSCFString orginalMethod:@selector(deleteCharactersInRange:) replaceMethod:@selector(qk_deleteCharactersInRange:)];
    });
}

#pragma mark - replaceCharactersInRange
- (void)qk_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    @try {
        [self qk_replaceCharactersInRange:range withString:aString];
    }
    @catch (NSException *exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
    }
}

#pragma mark - insertString:atIndex:
- (void)qk_insertString:(NSString *)aString atIndex:(NSUInteger)loc {
    
    @try {
        [self qk_insertString:aString atIndex:loc];
    }
    @catch (NSException *exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
    }
}

#pragma mark - deleteCharactersInRange

- (void)qk_deleteCharactersInRange:(NSRange)range {
    
    @try {
        [self qk_deleteCharactersInRange:range];
    }
    @catch (NSException *exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
    }
}
@end
