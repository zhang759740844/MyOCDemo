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
    // .a
//    return [UIImage imageNamed:[[[NSBundle mainBundle] pathForResource:@"StaticWithCocoapods" ofType:@"bundle"] stringByAppendingString:@"/author.png"]];
    // .framework
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    UIImage *image = [UIImage imageNamed:[[[NSBundle bundleForClass:self.class] pathForResource:@"StaticWithCocoapods" ofType:@"bundle" ] stringByAppendingString:@"/author.png"]];
    return image;
}
@end
