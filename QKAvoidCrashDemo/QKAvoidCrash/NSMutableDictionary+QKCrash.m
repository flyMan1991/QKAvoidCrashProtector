//
//  NSMutableDictionary+QKCrash.m
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/9.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import "NSMutableDictionary+QKCrash.h"
#import "NSObject+QKSwizzle.h"


@implementation NSMutableDictionary (QKCrash)

+ (void)qk_enableMutableDictionaryCrashProtector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class dictionryM = NSClassFromString(@"__NSDictionaryM");
        // setObject: forKey:
        [self qk_classSwizzleMethodWithClass:dictionryM orginalMethod:@selector(setObject:forKey:) replaceMethod:@selector(qk_setObject:forKey:)];
        
        // iOS11新增方法
        [self qk_classSwizzleMethodWithClass:dictionryM orginalMethod:@selector(setObject:forKeyedSubscript:) replaceMethod:@selector(qk_setObject:forKeyedSubscript:)];
        
        // removeObjectForKey:
        [self qk_classSwizzleMethodWithClass:dictionryM orginalMethod:@selector(removeObjectForKey:) replaceMethod:@selector(qk_removeObjectForKey:)];
    });
}
- (void)qk_setObject:(id)anObject  forKey:(id<NSCopying>)aKey {
    @try {
        [self qk_setObject:anObject forKey:aKey];
    }
    @catch (NSException * exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        
    }
}
- (void)qk_setObject:(id)anObject forKeyedSubscript:(id<NSCopying>)aKey {
    @try {
        [self qk_setObject:anObject forKey:aKey];
    }
    @catch (NSException * exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        
    }
}
- (void)qk_removeObjectForKey:(id<NSCopying>)aKey {
    @try {
        [self qk_removeObjectForKey:aKey];
    }
    @catch (NSException * exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        
    }
}
@end
