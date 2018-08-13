//
//  NSTimer+QKCrash.h
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/9.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  使用NSTimer的scheduledTimerWithTimeInterval:target:selector:userInfo:repeats: 方法 做重复做重复性的定时任务存在的一个问题:NSTimer会强引用targer实例,所以需要在何时的时候调用invalidate 定时器去释放他,否则就会由于定时器timer强引用target的关系导致target不能被释放,造成内存泄漏;甚至在定时任务触发时导致crash.
 
 *   点击屏幕时，系统会通过【scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:】生成一个NSTimer 来记录手指按住屏幕时的时长

 
 *   桥接层
 
 *   NSTimer强引用QKCPWeakProxy,QKCPWeakProxy弱引用target.
*    这样target和timer之间的关系变成弱引用了,意味着target可以自由的释放，从而解决了循环引用的问题
 
 
 *
 **/


@interface QKCPWeakProxy:NSProxy

@property (nonatomic, weak, readonly) id target;

- (instancetype)initWithTarget:(id)target;

+ (instancetype)proxyWithTarget:(id)target;

@end

@interface NSTimer (QKCrash)

+ (void)qk_enableTimerProtector;

@end
