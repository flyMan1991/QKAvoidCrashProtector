//
//  NSObject+QKSelectorCrash.m
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/8.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import "NSObject+QKSelectorCrash.h"

#import "NSObject+QKSwizzle.h"
#import "AvoidCrashStubProxy.h"



@implementation QKUnrecognizedSelectorSolveObject

+ (BOOL)resolveInstanceMethod:(SEL)sel {
        class_addMethod([self class], sel, (IMP)addMethod, "v@:@");
    return YES;
}




id addMethod(id self,SEL _cmd) {
//    NSLog(@"QKCrashProtector: unrecognized selector: %@", NSStringFromSelector(_cmd));
    NSString * crashClassName = [[NSUserDefaults standardUserDefaults] objectForKey:@"crashClassName"];
    NSLog(@"QKCrashProtector: unrecognized selector: [%@ %@]",crashClassName, NSStringFromSelector(_cmd));

    return 0;
}


@end

@implementation NSObject (QKSelectorCrash)

+ (void)qk_enableSelectorProtector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSObject * object = [[NSObject alloc] init];
        [object qk_instanceSwizzleMethod:@selector(forwardingTargetForSelector:) replaceMethod:@selector(qk_forwardingTargetForSelector:)];
        // 以下两个方法会引起程序崩溃,暂时舍弃
//        [object qk_instanceSwizzleMethod:@selector(methodSignatureForSelector:) replaceMethod:@selector(qk_methodSignatureForSelector:)];
//        [object qk_instanceSwizzleMethod:@selector(forwardInvocation:) replaceMethod:@selector(qk_forwardInvocation:)];
    });
}


- (id)qk_forwardingTargetForSelector:(SEL)aSelector {
    
    if (class_respondsToSelector([self class], @selector(forwardInvocation:))) {
        IMP impOfNSObject = class_getMethodImplementation([NSObject class], @selector(forwardInvocation:));
        IMP imp = class_getMethodImplementation([self class], @selector(forwardInvocation:));
        if (imp != impOfNSObject) {
            //NSLog(@"class has implemented invocation");
            return nil;
        }
    }
//
    NSString * crashClassName = NSStringFromClass([self class]);
    [[NSUserDefaults standardUserDefaults] setObject:crashClassName forKey:@"crashClassName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    QKUnrecognizedSelectorSolveObject *solveObject = [QKUnrecognizedSelectorSolveObject new];
    solveObject.objc = self;
    return solveObject;
//    NSString *crashMessages = [NSString stringWithFormat:@"JKCrashProtect: [%@ %@]: unrecognized selector sent to instance",self,NSStringFromSelector(aSelector)];
//    NSMethodSignature *signature = [QKUnrecognizedSelectorSolveObject instanceMethodSignatureForSelector:@selector(JKCrashProtectCollectCrashMessages:)];
//    [[QKUnrecognizedSelectorSolveObject new] JKCrashProtectCollectCrashMessages:crashMessages];
//    return signature;
}
- (id)qk_methodSignatureForSelector:(SEL)selector {
    NSMethodSignature *ms = [self qk_methodSignatureForSelector:selector];
    BOOL flag = NO;
    if (ms == nil) {
        ms = [AvoidCrashStubProxy instanceMethodSignatureForSelector:@selector(proxyMethod)];
        flag = YES;
    }
    if (flag == NO) {
        ms = [AvoidCrashStubProxy instanceMethodSignatureForSelector:@selector(proxyMethod)];

    }
//    return ms;
//    NSString *methodName =NSStringFromSelector(selector);
//    NSString *crashMessages = [NSString stringWithFormat:@"JKCrashProtect: [%@ %@]: unrecognized selector sent to instance",self,NSStringFromSelector(selector)];
//    NSMethodSignature *signature = [AvoidCrashStubProxy instanceMethodSignatureForSelector:@selector(proxyMethod)];
//    [[QKUnrecognizedSelectorSolveObject new] JKCrashProtectCollectCrashMessages:crashMessages];
    return ms;//对methodSignatureForSelector 进行重写，不然不会调用forwardInvocation方法

}
- (void)qk_forwardInvocation:(NSInvocation *)anInvocation {
//    @try {
//        [self qk_forwardInvocation:anInvocation];
//    }
//    @catch (NSException * exception) {
//        [QKCrashLog qk_noteErrorWithException:exception attachedTODO:@""];
//    }
//    @finally {
//
//    }
}
static NSMutableArray *noneSelClassStrings;
static NSMutableArray *noneSelClassStringPrefixs;

+ (void)setupNoneSelClassStringsArr:(NSArray<NSString *> *)classStrings {
    
    if (noneSelClassStrings) {
        
        NSString *warningMsg = [NSString stringWithFormat:@"\n[AvoidCrash setupNoneSelClassStringsArr:];\n调用一此即可，多次调用会自动忽略后面的调用\n"];
        NSLog(@"%@",warningMsg);
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        noneSelClassStrings = [NSMutableArray array];
        for (NSString *className in classStrings) {
            if ([className hasPrefix:@"UI"] == NO &&
                [className isEqualToString:NSStringFromClass([NSObject class])] == NO) {
                [noneSelClassStrings addObject:className];
                
            } else {
                NSString *warningMsg = [NSString stringWithFormat:@"\n[AvoidCrash setupNoneSelClassStringsArr:];\n会忽略UI开头的类和NSObject类(请使用NSObject的子类)\n\n"];
                NSLog(@"%@",warningMsg);
            }
        }
    });
}

/**
 *  初始化一个需要防止”unrecognized selector sent to instance”的崩溃的类名前缀的数组
 */
+ (void)setupNoneSelClassStringPrefixsArr:(NSArray<NSString *> *)classStringPrefixs {
    if (noneSelClassStringPrefixs) {
        
        NSString *warningMsg = [NSString stringWithFormat:@"\n[AvoidCrash setupNoneSelClassStringsArr:];\n会忽略UI开头的类和NSObject类(请使用NSObject的子类)\n\n"];
        NSLog(@"%@",warningMsg);
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        noneSelClassStringPrefixs = [NSMutableArray array];
        for (NSString *classNamePrefix in classStringPrefixs) {
            if ([classNamePrefix hasPrefix:@"UI"] == NO &&
                [classNamePrefix hasPrefix:@"NS"] == NO) {
                [noneSelClassStringPrefixs addObject:classNamePrefix];
                
            } else {
                NSString *warningMsg = [NSString stringWithFormat:@"\n[AvoidCrash setupNoneSelClassStringsArr:];\n会忽略UI开头的类和NSObject类(请使用NSObject的子类)\n\n"];
                NSLog(@"%@",warningMsg);
            }
        }
    });
}


@end
