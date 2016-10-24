//
//  ViewController.m
//  FrameworksTest
//
//  Created by Zachary on 2016/10/24.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import "ViewController.h"
#import "PrintString.h"
//#import "DynamicWithStatic/SVProgress.h"
//#import "DynamicWithDynamic/SVProgress.h"
//#import "StaticWithStatic.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [PrintString printString];
//    [SVProgress getBlock]();
}



@end
