//
//  NewImageView2.m
//  UIGestureRecognizer手势的创建和使用方法
//
//  Created by Zachary on 16/9/6.
//  Copyright © 2016年 shikee_Chan. All rights reserved.
//

#import "NewImageView2.h"

@implementation NewImageView2

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"横坐标%f，纵坐标%f",point.x,point.y);
    return self;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"image2 move");
    [super touchesMoved:touches withEvent:event];
}

@end
