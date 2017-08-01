//
//  ViewController.m
//  UICollectionViewDemo
//
//  Created by Zachary Zhang on 2017/7/27.
//  Copyright © 2017年 Zachary Zhang. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    button.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"点击查看" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
}

- (void)click {
    MainViewController *mainViewController = [[MainViewController alloc] init];
    UINavigationController *navViewController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    [self presentViewController:navViewController animated:YES completion:nil];
}



@end
