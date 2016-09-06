//
//  NewLayer.m
//  CALayer_transform
//
//  Created by Zachary on 16/9/6.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import "NewLayer.h"

@implementation NewLayer

-(void)drawInContext:(CGContextRef)ctx
{
    //1.绘制图形
    //画一个圆
    CGContextAddEllipseInRect(ctx, CGRectMake(50, 50, 100, 100));
    //设置属性（颜色）
    //    [[UIColor yellowColor]set];	不能这样设置
    CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
    //2.渲染
    CGContextFillPath(ctx);
}

@end
