//
//  NSObject+QKKVOCrash.h
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/8.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QKCPKVOInfo;

typedef void(^QKCPKVONotificationBlock)(id _Nullable observer,id object,NSDictionary<NSKeyValueChangeKey, id> * _Nullable change);

/**
 KVO的管理者
 KVO Crash fix
 */
@interface KVOProxy: NSObject

- (BOOL)qk_addObserver:(id _Nullable )object KVOinfo:(QKCPKVOInfo *_Nullable)KVOInfo;

- (void)qk_removeObserver:(id _Nullable )object keyPath:(NSString *_Nullable)keyPath block:(void(^_Nullable)(void)) block;

- (void)qk_removeAllObserver;

@end


/**
 KVO配置层
 */
@interface QKCPKVOInfo: NSObject
- (instancetype _Nullable )initWithKeyPath:(NSString *_Nullable)keyPath options:(NSKeyValueObservingOptions)options context:(void *_Nullable)context;

@end


@interface NSObject (QKKVOCrash)

@property (nonatomic, strong) KVOProxy * kvoProxy;

+ (void)qk_enableKVOProtector;

@end
