//
//  NSDictionary+QKCrash.m
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/9.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import "NSDictionary+QKCrash.h"
#import "NSObject+QKSwizzle.h"


@implementation NSDictionary (QKCrash)

+ (void)qk_enableDictionaryProtector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self qk_classSwizzleMethod:@selector(dictionaryWithObjects:forKeys:count:) replaceMethod:@selector(qk_dictionaryWithObjects:forKeys:count:)];
    });
}
+ (instancetype)qk_dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt {
    id instance = nil;
    @try {
        instance = [self qk_dictionaryWithObjects:objects forKeys:keys count:cnt];
    }
    @catch (NSException * exception) {
        // 默认改变空的键值对为空字符串,并且重新初始化一个字典
        NSString * defaultTodo = @"This framework default change nil key-values  to emptyStr and instance a dictionary.";
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:defaultTodo];
        
        // 处理错误的数据,然后重新初始化一个字典
        // 如果key为nil或者为空,移除key;如果key不为空,值为空,则将值置为@""
        
        NSUInteger index = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        id  _Nonnull __unsafe_unretained newkeys[cnt];
        for (int i = 0; i < cnt; i++) {
            if (keys[i]) {
                if (objects[i] == nil) {
                    newObjects[index] = @"";
                }else {
                    newObjects[index] = objects[i];
                }
                newkeys[index] = keys[i];
                index ++;
            }
        }
        instance = [self qk_dictionaryWithObjects:newObjects forKeys:newkeys count:index];
    }
    @finally {
        return instance;
    }
}

@end
