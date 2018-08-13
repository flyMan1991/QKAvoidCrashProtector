//
//  NSString+QKCrash.m
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/9.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import "NSString+QKCrash.h"
#import "NSObject+QKSwizzle.h"


@implementation NSString (QKCrash)

+ (void)qk_enableStringProtector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class __NSCFConstantString = NSClassFromString(@"__NSCFConstantString");
       // substringFromIndex
        [self qk_classSwizzleMethodWithClass:__NSCFConstantString orginalMethod:@selector(substringFromIndex:) replaceMethod:@selector(qk_substringFromIndex:)];
        
        // substringToIndex
        [self qk_classSwizzleMethodWithClass:__NSCFConstantString orginalMethod:@selector(substringToIndex:) replaceMethod:@selector(qk_substringToIndex:)];
        
        //substringWithRange:
        [self qk_instanceSwizzleMethodWithClass:__NSCFConstantString orginalMethod:@selector(substringWithRange:) replaceMethod:@selector(qk_substringWithRange:)];
        
        //characterAtIndex
        [self qk_instanceSwizzleMethodWithClass:__NSCFConstantString orginalMethod:@selector(characterAtIndex:) replaceMethod:@selector(qk_characterAtIndex:)];
        
        /* 注意swizzling先后顺序 👇： */
        //stringByReplacingOccurrencesOfString:withString:options:range:
        [self qk_instanceSwizzleMethodWithClass:__NSCFConstantString orginalMethod:@selector(stringByReplacingOccurrencesOfString:withString:options:range:) replaceMethod:@selector(qk_stringByReplacingOccurrencesOfString:withString:options:range:)];
        
        //stringByReplacingCharactersInRange:withString:
        [self qk_instanceSwizzleMethodWithClass:__NSCFConstantString orginalMethod:@selector(stringByReplacingCharactersInRange:withString:) replaceMethod:@selector(qk_stringByReplacingCharactersInRange:withString:)];
    });
}
#pragma mark -- substringFromIndex
- (NSString *)qk_substringFromIndex:(NSUInteger)index {
    NSString * subString = nil;
    @try {
        subString = [self substringFromIndex:index];
    }
    @catch (NSException * exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
        subString = nil;
    }
    @finally {
        return subString;
    }
}

#pragma mark -- substringFromIndex
- (NSString *)qk_substringToIndex:(NSUInteger)index {
    NSString * subString = nil;
    @try {
        subString = [self substringToIndex:index];
    }
    @catch (NSException * exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
        subString = nil;
    }
    @finally {
        return subString;
    }
}

#pragma mark - stringByReplacingCharactersInRange:withString:
- (NSString *)qk_stringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replaceStr {
    NSString * newStr = nil;
    @try {
        newStr = [self qk_stringByReplacingCharactersInRange:range withString:replaceStr];
    }
    @catch (NSException * exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
        newStr = nil;
    }
    @finally {
        return newStr;
    }
}

- (NSString *)qk_stringByReplacingOccurrencesOfString:(NSRange)range withString:(NSString *)replacement {
    
    NSString *newStr = nil;
    
    @try {
        newStr = [self qk_stringByReplacingOccurrencesOfString:range withString:replacement];
    }
    @catch (NSException *exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
        newStr = nil;
    }
    @finally {
        return newStr;
    }
}
#pragma mark - stringByReplacingOccurrencesOfString:withString:options:range:

- (NSString *)qk_stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange {
    
    NSString *newStr = nil;
    
    @try {
        newStr = [self qk_stringByReplacingOccurrencesOfString:target withString:replacement options:options range:searchRange];
    }
    @catch (NSException *exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
        newStr = nil;
    }
    @finally {
        return newStr;
    }
}

#pragma mark - substringWithRange:
- (NSString *)qk_substringWithRange:(NSRange)range {
    
    NSString *subString = nil;
    
    @try {
        subString = [self qk_substringWithRange:range];
    }
    @catch (NSException *exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
        subString = nil;
    }
    @finally {
        return subString;
    }
}


#pragma mark - characterAtIndex:

- (unichar)qk_characterAtIndex:(NSUInteger)index {
    
    unichar characteristic;
    @try {
        characteristic = [self qk_characterAtIndex:index];
    }
    @catch (NSException *exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        return characteristic;
    }
}






@end
