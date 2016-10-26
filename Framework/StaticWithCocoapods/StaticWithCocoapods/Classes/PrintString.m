//
//  PrintString.m
//  StaticLibrary
//
//  Created by Zachary on 2016/10/21.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import "PrintString.h"

@implementation PrintString

+ (void)printString{
    NSLog(@"由动态库打印的log");
}


+ (UIImage *)getImage{
//    [UIImage imageNamed:@"Frameworks.bundle/Image/author.png"]
//    return [UIImage imageNamed:[[[NSBundle mainBundle] pathForResource:@"Frameworks" ofType:@"bundle"] stringByAppendingString:@"/Images/author.png"]];
    return [UIImage imageNamed:[[[NSBundle mainBundle] pathForResource:@"StaticWithCocoapods" ofType:@"bundle"] stringByAppendingString:@"/author.png"]];
}
@end
