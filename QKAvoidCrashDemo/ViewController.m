//
//  ViewController.m
//  QKAvoidCrashDemo
//
//  Created by qk365 on 2018/8/7.
//  Copyright © 2018年 qk365. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *testBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self test];
//    [self test1];
    [self.testBtn addTarget:self action:@selector(test1) forControlEvents:UIControlEventTouchUpInside];
}

- (void)test {
    NSMutableArray * arr = [NSMutableArray array];
    NSString * str1 = nil;
    [arr addObject:str1];
}
- (void)test1 {
    NSMutableArray * arr = [NSMutableArray array];
    [arr addObject:@"124"];
    NSString * str1 = nil;
    [arr addObject:str1];
    
    NSDictionary * testDic = @{
                               @"key1":str1,
                               @"key2":@"sss"
                               };
    NSLog(@"testDic:%@",testDic);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
