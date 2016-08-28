//
//  ViewController.m
//  MyButton
//
//  Created by Zachary on 16/8/28.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property  (nonatomic, weak) IBOutlet UIButton *btn2;
@property (nonatomic, weak) UIButton *button;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBtn1];

    
}

- (void)setBtn1{
    UIButton *btn1 = [[UIButton alloc] init];
    
    CGRect btn1Frame = CGRectMake(50, 50, 200, 100);
    btn1.frame = btn1Frame;
    [btn1 setBackgroundColor:[UIColor blueColor]];
    [btn1 setImage:[UIImage imageNamed:@"Image"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"Image"] forState:UIControlStateHighlighted];
    [btn1 setImage:[UIImage imageNamed:@"Image2"] forState:UIControlStateSelected];
    //选中时候的高亮状态
    [btn1 setImage:[UIImage imageNamed:@"Image2"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [btn1 addTarget:self action:@selector(btn1Pressed:) forControlEvents:UIControlEventTouchUpInside];
    //要设置title的颜色，否则就是白色和背景色相同，看不见
    [btn1 setTitle:@"BTN1" forState:UIControlStateNormal];
    //buton image和label互换
    //一定要先设置title再设置image。因为title是依赖于image的，在如果先设置image，这个时候title还没有确定，于是titleLabel.bounds.size.width一定是0，即image没有变。
        [btn1 setTitle:[NSString stringWithFormat:@"asdasdasdasdasda" ] forState:UIControlStateNormal];
    [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn1.imageView.bounds.size.width, 0, btn1.imageView.bounds.size.width)];
    [btn1 setImageEdgeInsets:UIEdgeInsetsMake(0, btn1.titleLabel.bounds.size.width, 0, -btn1.titleLabel.bounds.size.width)];
[btn1 setTitle:[NSString stringWithFormat:@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" ] forState:UIControlStateNormal];


    [self.view addSubview:btn1];
    _button = btn1;
}

//点击事件
- (void)btn1Pressed:(UIButton *)button{
    //button.enabled 设置是否可点击。
    button.selected = !button.selected;
}


//去除点击事件
- (IBAction)btn2Pressed:(id)sender{
    NSLog(@"---");
    [_button removeTarget:self action:@selector(btn1Pressed:) forControlEvents:UIControlEventTouchUpInside];
}
@end
