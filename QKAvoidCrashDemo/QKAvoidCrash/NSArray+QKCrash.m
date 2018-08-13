//
//  NSArray+QKCrash.m
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/8.
//  Copyright © 2018年 qk365. All rights reserved.
//
/**
 
 iOS 8:下都是__NSArrayI
 iOS11: 之后分 __NSArrayI、  __NSArray0、__NSSingleObjectArrayI
 
 iOS11之前：arr@[]  调用的是[__NSArrayI objectAtIndexed]
 iOS11之后：arr@[]  调用的是[__NSArrayI objectAtIndexedSubscript]
 
 arr为空数组
 *** -[__NSArray0 objectAtIndex:]: index 12 beyond bounds for empty NSArray
 
 arr只有一个元素
 *** -[__NSSingleObjectArrayI objectAtIndex:]: index 12 beyond bounds [0 .. 0]
 
 */
#import "NSArray+QKCrash.h"
#import "NSObject+QKSwizzle.h"


@implementation NSArray (QKCrash)
+ (void)qk_enableArrayProtector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //====================
        //   instance method
        //====================
        Class __NSArray = objc_getClass("NSArray");
        Class __NSArrayI = objc_getClass("__NSArrayI");
        Class __NSSingleObjectArrayI = objc_getClass("__NSSingleObjectArrayI");
        Class __NSArray0 = objc_getClass("__NSArray0");
        
        [self qk_classSwizzleMethodWithClass:__NSArray orginalMethod:@selector(arrayWithObjects:count:) replaceMethod:@selector(qk_arrayWithObjects:count:)];
        
        // objectAtIndex:
        /* 数组count >= 2 */
        [self qk_instanceSwizzleMethodWithClass:__NSArrayI orginalMethod:@selector(objectAtIndex:) replaceMethod:@selector(qk_objectAtIndex:)];//[arr objectAtIndex:];
        
        [self qk_instanceSwizzleMethodWithClass:__NSArrayI orginalMethod:@selector(objectAtIndexedSubscript:) replaceMethod:@selector(qk_objectAtIndexedSubscript:)];//arr[];
        
        /* 数组为空 */
        [self qk_instanceSwizzleMethodWithClass:__NSArray0 orginalMethod:@selector(objectAtIndex:) replaceMethod:@selector(qk_objectAtIndexedNullarray:)];
        
        /* 数组count == 1 */
        [self qk_instanceSwizzleMethodWithClass:__NSSingleObjectArrayI orginalMethod:@selector(objectAtIndex:) replaceMethod:@selector(qk_objectAtIndexedArrayCountOnlyOne:)];
        
        // objectsAtIndexes:
        [self qk_instanceSwizzleMethodWithClass:__NSArray orginalMethod:@selector(objectsAtIndexes:) replaceMethod:@selector(qk_objectsAtIndexes:)];
        
        // 以下方法调用频繁，替换可能会影响性能
        // getObjects:range:
        [self qk_instanceSwizzleMethodWithClass:__NSArray orginalMethod:@selector(getObjects:range:) replaceMethod:@selector(qk_getObjectsNSArray:range:)];
        [self qk_instanceSwizzleMethodWithClass:__NSSingleObjectArrayI orginalMethod:@selector(getObjects:range:) replaceMethod:@selector(qk_getObjectsNSSingleObjectArrayI:range:)];
        [self qk_instanceSwizzleMethodWithClass:__NSArrayI orginalMethod:@selector(getObjects:range:) replaceMethod:@selector(qk_getObjectsNSArrayI:range:)];
    });
}

#pragma mark - instance array
+ (instancetype)qk_arrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt {
    
    id instance = nil;
    
    @try {
        instance = [self qk_arrayWithObjects:objects count:cnt];
    }
    @catch (NSException *exception) {
        
        NSString *defaultToDo = @"This framework default is to remove nil object and instance a array.";
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:defaultToDo];
        
        //以下是对错误数据的处理，把为nil的数据去掉,然后初始化数组
        NSInteger newObjsIndex = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] != nil) {
                newObjects[newObjsIndex] = objects[i];
                newObjsIndex++;
            }
        }
        instance = [self qk_arrayWithObjects:newObjects count:newObjsIndex];
    }
    @finally {
        return instance;
    }
}


- (id)qk_objectAtIndex:(NSUInteger)index {
    //    if (index >= self.count) {
    //        [qkCrashLog printCrashMsg:[NSString stringWithFormat:@"-%s: index %ld beyond bounds [0 .. %lu]",__func__,index,(unsigned long)self.count]];
    //        return nil;
    //    }
    //    return [self qk_objectAtIndex:index];
    
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
        object = [self qk_objectAtIndexedSubscript:index];
    }
    @catch (NSException *exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        return object;
    }
}

- (id)qk_objectAtIndexedNullarray:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self qk_objectAtIndexedNullarray:index];
    }
    @catch (NSException *exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        return object;
    }
}

- (id)qk_objectAtIndexedArrayCountOnlyOne:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self qk_objectAtIndexedArrayCountOnlyOne:index];
    }
    @catch (NSException *exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        return object;
    }
}

- (NSArray *)qk_objectsAtIndexes:(NSIndexSet *)indexes {
    NSArray *returnArray = nil;
    @try {
        returnArray = [self qk_objectsAtIndexes:indexes];
    } @catch (NSException *exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
        
    } @finally {
        return returnArray;
    }
}

#pragma mark getObjects:range:
- (void)qk_getObjectsNSArray:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    @try {
        [self qk_getObjectsNSArray:objects range:range];
    } @catch (NSException *exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    } @finally {
    }
}

- (void)qk_getObjectsNSSingleObjectArrayI:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    @try {
        [self qk_getObjectsNSSingleObjectArrayI:objects range:range];
    } @catch (NSException *exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    } @finally {
    }
}

- (void)qk_getObjectsNSArrayI:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    @try {
        [self qk_getObjectsNSArrayI:objects range:range];
    } @catch (NSException *exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    } @finally {
    }
}


                  
@end
