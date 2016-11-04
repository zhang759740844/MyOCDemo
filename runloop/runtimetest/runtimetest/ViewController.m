//
//  ViewController.m
//  runtimetest
//
//  Created by Zachary on 2016/10/28.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong,nonatomic)NSThread *thread; //记得使用Strong属性

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.thread = [[NSThread alloc]initWithTarget:self selector:@selector(threadMethod) object:nil];
    [self.thread start]; //启动子线程
}

- (IBAction)showSource:(id)sender{
    NSLog(@"这里是主线程：%@",[NSThread currentThread]);
    [self performSelector:@selector(threadSelector) onThread:self.thread withObject:nil waitUntilDone:NO];
}

-(void)threadMethod{
    NSLog(@"打开子线程方法");
    while (1) {
        [[NSRunLoop currentRunLoop]run];
        NSLog(@"这里是threadMethod：%@", [NSThread currentThread]);
    }
}

-(void)threadSelector{
    NSLog(@"打开子线程Selector源");
    NSLog(@"此处是threadSelector源：%@",[NSThread currentThread]);
}

@end
