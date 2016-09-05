//
//  ViewController.m
//  UIGestureRecognizer手势的创建和使用方法
//
//  Created by 陈家庆 on 15-2-7.
//  Copyright (c) 2015年 shikee_Chan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-150)/2, (self.view.frame.size.height-150)/2, 150, 150)];
    _imageView.userInteractionEnabled = YES;//交互使能，允许界面交互，不设置就不能动
    _imageView.image = [UIImage imageNamed:@"cat"];
    [self.view addSubview:_imageView];
    
    // 单击的 TapRecognizer
    UITapGestureRecognizer *singleTap;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleTap.numberOfTapsRequired = 1; //点击的次数 ＝1 单击
    
    [_imageView addGestureRecognizer:singleTap];//给对象添加一个手势监测；
    
    // 双击的 TapRecognizer
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleTap:)];
    doubleTap.numberOfTapsRequired = 2; //点击的次数 ＝2 双击
    [_imageView addGestureRecognizer:doubleTap];//给对象添加一个手势监测；
    
    /*
     1.双击手势确定监测失败才会触发单击手势的相应操作，否则双击时第一击时会响应单击事件
     2.会造成单击时要判断是否是双击，调用单击会有所延时。属正常现象。
     */
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    
    //捏合缩放手势 Pinch
    UIPinchGestureRecognizer *pinch;
    pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    //    [_imageView addGestureRecognizer:pinch];//添加到_imageView的时候，是要把手指放到_imageView操作
    [self.view addGestureRecognizer:pinch];//是self的时候，操作整个view都可以捏合_imageView（在响应事件中操作）
    pinch.delegate = self;
    
    
    //旋转手势 Rotation
    UIRotationGestureRecognizer *rotateRecognizer = [[UIRotationGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(handleRotate:)];
    [self.view addGestureRecognizer:rotateRecognizer];//是self的时候，操作整个view都可以捏合_imageView（在响应事件中操作）
    rotateRecognizer.delegate = self;
    
    
    //滑动手势 SwipeRecognizer
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(handleSwipe:)];
    [self.view addGestureRecognizer:swipeRecognizer];//是self的时候，操作整个view都可以捏合_imageView（在响应事件中操作）
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;//操作为左滑
    swipeRecognizer.delegate = self;

    
    //拖动手势 PanRecognizer
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(handlePan:)];
    [_imageView addGestureRecognizer:panRecognizer];//关键语句，添加一个手势监测；
    panRecognizer.maximumNumberOfTouches = 1;
//    panRecognizer.delegate = self;
    
    //长按手势 LongPressRecognizer
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]
                                                         initWithTarget:self
                                                         action:@selector(handlelongPress:)];
    [_imageView addGestureRecognizer:longPressRecognizer];
    longPressRecognizer.minimumPressDuration = 1.0f;//触发长按事件时间为：1.0秒
    longPressRecognizer.delegate = self;
    
}

-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    //处理单击操作
    NSLog(@"单击操作");
}

-(void)DoubleTap:(UITapGestureRecognizer*)recognizer
{
    //处理双击操作
    NSLog(@"双击操作");
}

- (void)handlePinch:(UIPinchGestureRecognizer*)recognizer
{
    NSLog(@"缩放操作");//处理缩放操作
    //对imageview缩放
    _imageView.transform = CGAffineTransformScale(_imageView.transform, recognizer.scale, recognizer.scale);
    //对self.view缩放，因为recognizer是添加在self.view上的
    //recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

- (void)handleRotate:(UIRotationGestureRecognizer*) recognizer
{
    NSLog(@"旋转操作");//处理旋转操作
    //对imageview旋转
    _imageView.transform = CGAffineTransformRotate(_imageView.transform, recognizer.rotation);
    //对self.view旋转，因为recognizer是添加在self.view上的
    //    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    NSLog(@"%f",recognizer.rotation);
    recognizer.rotation = 0;    //一定要清零
}

- (void)handleSwipe:(UISwipeGestureRecognizer*) recognizer
{
    //处理滑动操作
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"左滑滑动操作");
    }else if(recognizer.direction==UISwipeGestureRecognizerDirectionRight){
        NSLog(@"右滑滑动操作");
    }
}

-(void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    NSLog(@"拖动操作");
    //处理拖动操作,拖动是基于imageview，如果经过旋转，拖动方向也是相对imageview上下左右移动，而不是屏幕对上下左右
    CGPoint translation = [recognizer translationInView:_imageView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:_imageView];
}

-(void)handlelongPress:(UILongPressGestureRecognizer*)recognizer
{
    //处理长按操作,开始结束都会调用，所以长按1次会执行2次
    if(recognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"开始长按操作");
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"结束长按操作");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return YES;
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0){
//    
//    return YES;
//}
//下面这个两个方法也是用来控制手势的互斥执行的
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
