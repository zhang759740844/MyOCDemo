//
//  ViewController_2.m
//  OCWithSwift
//
//  Created by Zachary Zhang on 2017/7/5.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

#import "ViewController_2.h"
#import "OCWithSwift-Swift.h"
#import "OCFile.h"

@implementation ViewController_2
+ (void)helloWorld{
    SwiftFile *s = [[SwiftFile alloc] init];
    [s helloWorld];
    OCFile *f = [[OCFile alloc] init];
    [f helloWorld];
    
}
@end
