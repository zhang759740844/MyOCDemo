//
//  ViewController.m
//  CALayer_transform
//
//  Created by Zachary on 16/9/2.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIView *leftArm;


@property (nonatomic, weak) IBOutlet UIView *leftHand;


@property (nonatomic, weak) IBOutlet UIButton *button;

@property (nonatomic, weak) IBOutlet UIButton *button2;


@property (nonatomic, assign) CGFloat offsetLX;

@property (nonatomic, assign) CGFloat offsetLY;

@end

@implementation ViewController


- (void)awakeFromNib{

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _offsetLX = 0 ;
    _offsetLY = 0;
    _leftArm.transform = CGAffineTransformMakeTranslation(_offsetLX, _offsetLY);
    // Do any additional setup after loading the view, typically from a nib.
    [self.button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 addTarget:self action:@selector(button2Pressed) forControlEvents:UIControlEventTouchUpInside];

}

- (void)buttonPressed{
    _button.selected = !_button.selected;
    [self startAnim:_button.selected];
}

- (void)button2Pressed{
    _button2.selected = !_button2.selected;
    [self startAnim2:_button2.selected];
}

- (void)startAnim2:(BOOL)isSelected{
    NSLog(@"origin: %f,%f",_leftArm.frame.origin.x,_leftArm.frame.origin.y);
    NSLog(@"size:   %f,%f",_leftArm.frame.size.height,_leftArm.frame.size.width);
    if (isSelected) {
        [UIView animateWithDuration:2 animations:^{
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = -1.0/40.0f;
            transform = CATransform3DRotate(transform, M_PI_2/4,0 , 1, 0);
            _leftArm.layer.transform = transform;
            NSLog(@"origin: %f,%f",_leftArm.frame.origin.x,_leftArm.frame.origin.y);
            NSLog(@"size:   %f,%f",_leftArm.frame.size.height,_leftArm.frame.size.width);
        }];
    }else{
        [UIView animateWithDuration:2 animations:^{
        CATransform3D transform = CATransform3DIdentity;
        _leftArm.layer.transform = transform;
        NSLog(@"origin: %f,%f",_leftArm.frame.origin.x,_leftArm.frame.origin.y);
        NSLog(@"size:   %f,%f",_leftArm.frame.size.height,_leftArm.frame.size.width);
            }];
    }
}

- (void)startAnim:(BOOL)isCoverEye
{
    NSLog(@"origin: %f,%f",_leftArm.frame.origin.x,_leftArm.frame.origin.y);
    NSLog(@"size:   %f,%f",_leftArm.frame.size.height,_leftArm.frame.size.width);
    if (isCoverEye) {

        [UIView animateWithDuration:2 animations:^{
            // 动画
            // 手臂
            _leftArm.transform = CGAffineTransformMakeTranslation(100, 100);    //  移动是相对于原始view的，而不是在前一个的基础上再做移动
            // 手
            CGAffineTransform lTransform = CGAffineTransformMakeTranslation(100, 100 + 5);
            lTransform = CGAffineTransformScale(lTransform, 0.01, 0.01);
            _leftHand.transform = lTransform;
//            CGAffineTransform transform2 = CGAffineTransformMakeScale(0.01, 0.01);
//            _leftHand.transform = transform2;
        }];
        NSLog(@"origin: %f,%f",_leftArm.frame.origin.x,_leftArm.frame.origin.y);
        NSLog(@"size:   %f,%f",_leftArm.frame.size.height,_leftArm.frame.size.width);
    }else{

        [UIView animateWithDuration:0.25 animations:^{
            
            // 手形变还原
            // CGAffineTransformIdentity:所有形变参数都是0
            _leftHand.transform = CGAffineTransformIdentity;
            
            // 手臂
            _leftArm.transform = CGAffineTransformMakeTranslation(_offsetLX, _offsetLY);

        }];
        NSLog(@"origin: %f,%f",_leftArm.frame.origin.x,_leftArm.frame.origin.y);
        NSLog(@"size:   %f,%f",_leftArm.frame.size.height,_leftArm.frame.size.width);
    }
    
}

@end
