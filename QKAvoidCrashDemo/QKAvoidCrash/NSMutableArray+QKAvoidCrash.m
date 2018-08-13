//
//  NSMutableArray+QKAvoidCrash.m
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/7.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import "NSMutableArray+QKAvoidCrash.h"
#import "NSObject+QKSwizzle.h"
@implementation NSMutableArray (QKAvoidCrash)

+ (void)qk_enableMutableArrayProtector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 实例方法
        Class __NSArrayM = NSClassFromString(@"__NSArrayM");
        // objectAtIndex:
        [self qk_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(objectAtIndex:) replaceMethod:@selector(qk_objectAtIndex:)];
        [self qk_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(objectAtIndexedSubscript:) replaceMethod:@selector(qk_objectAtIndexedSubscript:)];
        
        //insertObject:atIndex:
        [self qk_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(insertObject:atIndex:) replaceMethod:@selector(qk_insertObject:atIndex:)];
        //addObject:
        [self qk_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(addObject:) replaceMethod:@selector(qk_addObject:)];

        //removeObjectAtIndex:
        [self qk_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(removeObjectAtIndex:) replaceMethod:@selector(qk_removeObjectAtIndex:)];
        //removeObject:
        [self qk_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(removeObject:) replaceMethod:@selector(qk_removeObject:)];
        
        
        
        //setObject:atIndexedSubscript:
        [self qk_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(setObject:atIndexedSubscript:) replaceMethod:@selector(qk_setObject:atIndexedSubscript:)];
        
        [self qk_instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(getObjects:range:) replaceMethod:@selector(qk_getObjects:range:)];
        
        
    });
}

- (id)qk_objectAtIndex:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self qk_objectAtIndex:index];
    }
    @catch (NSException *exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        return object;
    }
}

- (id)qk_objectAtIndexedSubscript:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self qk_objectAtIndex:index];
    }
    @catch(NSException * exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        return object;
    }
}


- (void)qk_insertObject:(id)anObject  atIndex:(NSUInteger)index {
    @try {
        [self qk_insertObject:anObject atIndex:index];
    }
    @catch(NSException * exception){
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        
    }
}

- (void)qk_addObject:(id)anObject {
    @try {
        [self qk_addObject:anObject];
    }
    @catch (NSException * exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        
    }
}

- (void)qk_removeObjectAtIndex:(NSUInteger)index {
    @try {
        [self qk_removeObjectAtIndex:index];
    }
    @catch (NSException * exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        
    }
}
- (void)qk_removeObject:(id)obj {
    @try {
        [self qk_removeObject:obj];
    }
    @catch (NSException * exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        
    }
}

- (void)qk_setObject:(id)obj atIndexedSubscript:(NSInteger)index {
    @try {
        [self qk_setObject:obj atIndexedSubscript:index];
    }
    @catch (NSException * exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        
    }
}


- (void)qk_getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    @try {
        [self qk_getObjects:objects range:range];
    }
    @catch (NSException * exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        
    }
}



@end
