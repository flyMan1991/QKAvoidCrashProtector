//
//  NSObject+QKKVOCrash.m
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/8.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import "NSObject+QKKVOCrash.h"
#import "NSObject+QKSwizzle.h"
#import <pthread.h>

#pragma mark - KVOProxy
/*
 此类用来管理混乱的KVO关系
     让被观察对象持有一个KVO的delegate,所有和KVO相关的操作均通过delegate来进行管理,
     delegate通过建立一张map来维持KVO整个关系
 
 好处: 不会crash,
    1 如果出现KVO重复添加观察者/移除观察者情况,delegate可以阻止这些非正常操作
    2.被观察对象dealloc之前,可以通过delegate 自动将与自己有关的KVO关系都注销掉,避免了KVO的被观察者dealloc时仍然注册着KVO导致的crash。
 
 注意:
 重复添加观察者不会crash,即不会走@catch
 多次添加对同一个属性观察的观察者，系统方法内部会强应用这个观察者，同理即可remove该观察者同样次数。
 
 */

@implementation KVOProxy {
    pthread_mutex_t _mutex;
    NSMapTable<id,NSMutableSet<QKCPKVOInfo *>*> *_objectInfoMap;// map来维持整个KVO关系
}

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        _objectInfoMap = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPointerPersonality valueOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPersonality capacity:0];
        pthread_mutex_init(&_mutex, NULL);
    }
    return self;
}
- (BOOL)qk_addObserver:(id)object KVOinfo:(QKCPKVOInfo *)KVOInfo {
    // 增加线程互斥锁,保证安全
    [self lock];
    // QKKVOInfo 存入KVO的信息,object为注册对象
    NSMutableSet * infos = [_objectInfoMap objectForKey:object];
    __block BOOL isHas = NO;
    [infos enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if([[KVOInfo valueForKey:@"_keyPath"] isEqualToString:[obj valueForKey:@"_keyPath"]]){
            *stop = YES;
            isHas = YES;
        }
        
    }];
    if (isHas) {
        [self unlock];
        NSLog(@"crash add observer: %@,keyPath: %@",object,KVOInfo);
        return NO;
    }
    if (infos  == nil) {
        infos = [NSMutableSet set];
        [_objectInfoMap setObject:infos forKey:object];
    }
    [infos addObject:KVOInfo];
    [self unlock];
    return YES;
}

- (void)qk_removeObserver:(id)object keyPath:(NSString *)keyPath block:(void (^)(void))block
{
    //    if (!object || !keyPath) {
    //        return;
    //    }
    
    [self lock];
    NSMutableSet *infos = [_objectInfoMap objectForKey:object];
    __block QKCPKVOInfo *info;
    [infos enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if([keyPath isEqualToString:[obj valueForKey:@"_keyPath"]]){
            info = (QKCPKVOInfo *)obj;
            *stop = YES;
        }
    }];
    
    if (info != nil) {
        [infos removeObject:info];
        block();
        if (0 == infos.count) {
            [_objectInfoMap removeObjectForKey:object];
        }
    }else {
        [QKCrashLog printCrashMsg:[NSString stringWithFormat:@"Cannot remove an observer %@ for the key path '%@' from %@ because it is not registered as an observer.",object,keyPath,self]];
    }
    [self unlock];
}
- (void)qk_removeAllObserver {
    if (_objectInfoMap) {
        NSMapTable *objectInfoMaps = [_objectInfoMap copy];
        for (id object in objectInfoMaps) {
            
            NSSet *infos = [objectInfoMaps objectForKey:object];
            if(nil==infos || infos.count==0) continue;
            [infos enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
                QKCPKVOInfo *info = (QKCPKVOInfo *)obj;
                [object removeObserver:self forKeyPath:[info valueForKey:@"_keyPath"]];
            }];
        }
        [_objectInfoMap removeAllObjects];
    }
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
    NSLog(@"KVOProxy - observeValueForKeyPath :%@",change);
    __block QKCPKVOInfo *info ;
    {
        [self lock];
        NSSet *infos = [_objectInfoMap objectForKey:object];
        [infos enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            if([keyPath isEqualToString:[obj valueForKey:@"_keyPath"]]){
                info = (QKCPKVOInfo *)obj;
                *stop = YES;
            }
        }];
        [self unlock];
    }
    
    if (nil != info) {
        [object observeValueForKeyPath:keyPath ofObject:object change:change context:(__bridge void * _Nullable)([info valueForKey:@"_context"])];
    }
}

// 线程互斥锁
- (void)lock {
    pthread_mutex_lock(&_mutex);
}
// 线程互斥解锁
- (void)unlock {
    pthread_mutex_unlock(&_mutex);
}
- (void)dealloc {
    pthread_mutex_destroy(&_mutex);
}
@end


#pragma mark - WOCPKVOInfo
@implementation QKCPKVOInfo {
@public
    NSString *_keyPath;
    NSKeyValueObservingOptions _options;
    SEL _action;
    void *_context;
    QKCPKVONotificationBlock _block;
}

- (instancetype)initWithKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    return [self initWithKeyPath:keyPath options:options block:NULL action:NULL context:context];
}

- (instancetype)initWithKeyPath:(NSString *)keyPath
                        options:(NSKeyValueObservingOptions)options
                          block:(nullable QKCPKVONotificationBlock)block
                         action:(nullable SEL)action
                        context:(nullable void *)context {
    self = [super init];
    if (nil != self) {
        _block = [block copy];
        _keyPath = [keyPath copy];
        _options = options;
        _action = action;
        _context = context;
    }
    return self;
}

@end



#pragma mark - NSObject + QKKVOCrash
/**
 
 ①、警告⚠️：
 1、重复添加相同的keyPath观察者，会重复调用 observeValueForKeyPath：...方法
 
 ②、crash情况：
 1、移除未被以KVO注册的观察者 会crash
 2、重复移除观察者 会crash
 
 */

// fix "unrecognized selector" ,"KVC"
static void *NSObjectKVOProxyKey = &NSObjectKVOProxyKey;

static int const QKNSObjectKVOCrashKey;

@implementation NSObject (QKKVOCrash)

+ (void)qk_enableKVOProtector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSObject * obj = [[NSObject alloc] init];
        [obj qk_instanceSwizzleMethod:@selector(addObserver:forKeyPath:options:context:) replaceMethod:@selector(qk_addObserver:forKeyPath:options:context:)];
        [obj qk_instanceSwizzleMethod:@selector(removeObserver:forKeyPath:) replaceMethod:@selector(qk_removeObserver:forKeyPath:)];
    });
}

/// 添加观察者，实际添加QKCPKVOInfo -> KVO的管理者，来管理KVO的注册
/**
 keyPath为对象的属性，通过keyPath作为Key创建对应对应的一条观察者关键路径：keyPath --> observer(self)
 
 */

- (void)qk_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    @try {
        [self qk_addObserver:observer forKeyPath:keyPath options:options context:context];
    }
    @catch (NSException * exception) {
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        if (!observer || !keyPath) {
            return;
        }
        NSHashTable *observers = self.keyPathInfos[keyPath];
        if (observers && [observers containsObject:observer]) {
            //        [WOCrashLog printCrashMsg:[NSString stringWithFormat:@"CrashProtector: Repeat adding the same keyPath observer: %@, keyPath: %@", observer, keyPath]];
            return;
        }
        if (!observers) {
            observers = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
        }
        [observers addObject:observer];
        [self.keyPathInfos setObject:observers forKey:keyPath];
        
    }
}
- (void)qk_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    @try {
        [self qk_removeObserver:observer forKeyPath:keyPath];
    }
    @catch (NSException *exception) {
        // 打印crash信息
        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
    }
    @finally {
        
        if (!observer || !keyPath) {
            return;
        }
        NSHashTable *observers = self.keyPathInfos[keyPath];
        // keyPath集合中未包含这个观察者，即移除未被以KVO注册的观察者
        if (!observers) {
            return;
        }
        // 重复删除观察者
        if (![observers containsObject:observer]) {
           
            return;
        }
        [observers removeObject:observer];
        [self.keyPathInfos setObject:observers forKey:keyPath];
    }
}
#pragma mark -- setter/getter
- (NSMutableDictionary *)keyPathInfos {
    NSMutableDictionary * dict = objc_getAssociatedObject(self, &QKNSObjectKVOCrashKey);
    if (!dict) {
        dict = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &QKNSObjectKVOCrashKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
}

- (void)setKeyPathInfos:(NSMutableDictionary *)keyPathInfos {
    objc_setAssociatedObject(self, &QKNSObjectKVOCrashKey, keyPathInfos, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (KVOProxy *)kvoProxy {
    id proxy = objc_getAssociatedObject(self, NSObjectKVOProxyKey);
    
    if (!proxy) {
        proxy = [[KVOProxy alloc] init];
        self.kvoProxy = proxy;
    }
    
    return proxy;

}

- (void)setKvoProxy:(KVOProxy *)kvoProxy {
    objc_setAssociatedObject(self, NSObjectKVOProxyKey, kvoProxy, OBJC_ASSOCIATION_ASSIGN);
}

@end
