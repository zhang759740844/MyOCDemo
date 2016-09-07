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

@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;


@property (nonatomic, assign) CGFloat offsetLX;

@property (nonatomic, assign) CGFloat offsetLY;

@end

@implementation ViewController


- (void)awakeFromNib{

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //CALayer 简单使用
    [self simplyUseCALayer];
    //CALayer 创建图层
    [self createCALayer];
    //CALayer 属性
    [self properties];
    //CALayer 自定义图层
    [self customLayer];
    //CALayer的transform属性
    [self setTransform];

}

#pragma mark - CALayer简单使用
- (void)simplyUseCALayer{
    //设置边框的宽度为20
    self.customView.layer.borderWidth=10;
    //设置边框的颜色(borderColor是CGColor类型)
    self.customView.layer.borderColor=[UIColor greenColor].CGColor;
    //设置layer的圆角
    self.customView.layer.cornerRadius=20;
    //设置超过子图层的部分裁减掉
    self.customView.layer.masksToBounds=YES;
    //在view的图层上添加一个image，contents表示接受内容
    self.customView.layer.contents=(id)[UIImage imageNamed:@"cat"].CGImage;
    //由于设置了masksToBounds，因此下面设置阴影部分由于在View之外，就无效了。
    //设置阴影的颜色
    self.customView.layer.shadowColor=[UIColor blackColor].CGColor;
    //设置阴影的偏移量，如果为正数，则代表为往右边偏移
    self.customView.layer.shadowOffset=CGSizeMake(15, 5);
    //设置阴影的透明度(0~1之间，0表示完全透明)
    self.customView.layer.shadowOpacity=0.6;
    
    
    //设置图片layer的边框宽度和颜色
    self.iconView.layer.borderColor=[UIColor brownColor].CGColor;
    self.iconView.layer.borderWidth=5;
    //设置layer的圆角
    self.iconView.layer.cornerRadius=20;
    //设置超过子图层的部分裁减掉
    self.iconView.layer.masksToBounds=YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //通过uiview设置（2D效果）
    //    self.iconView.transform=CGAffineTransformMakeTranslation(0, -100);
    //通过layer来设置（3D效果,x，y，z三个方向）
    //    self.iconView.layer.transform=CATransform3DMakeTranslation(100, 20, 0);
    CATransform3D t3d = CATransform3DMakeTranslation(100, 20, 0);
    self.iconView.layer.transform = CATransform3DRotate(t3d, M_PI_4, 1, 1, 0.5);
}

# pragma mark - 创建 图层
- (void)createCALayer{
    CALayer *Mylayer=[CALayer layer];
    //设置layer的属性
    Mylayer.bounds=CGRectMake(0, 0, 100, 100);
    Mylayer.position=CGPointMake(100, 100);
    
    //设置需要显示的图片
    Mylayer.contents=(id)[UIImage imageNamed:@"cat"].CGImage;
    //设置圆角半径为10
    Mylayer.cornerRadius=10;
    //如果设置了图片，那么需要设置这个属性为YES才能显示圆角效果
    Mylayer.masksToBounds=YES;
    //设置边框
    Mylayer.borderWidth=3;
    Mylayer.borderColor=[UIColor brownColor].CGColor;
    
    //把layer添加到界面上
    [self.view.layer addSublayer:Mylayer];
}

# pragma mark - CALayer 属性
- (void)properties{
    //创建图层
    CALayer *layer=[CALayer layer];
    //设置图层的属性
    layer.backgroundColor=[UIColor redColor].CGColor;
    layer.bounds=CGRectMake(100, 100, 100, 100);
    layer.position=CGPointMake(0, 100);
    //设置锚点为（0，0）
    layer.anchorPoint=CGPointZero;
    //添加图层
    [self.view.layer addSublayer:layer];
}

# pragma mark - CALayer 自定义
- (void)customLayer{
    //方法1 创建类
    //1.创建自定义的layer
    NewLayer *layer=[NewLayer layer];
    //2.设置layer的属性
    layer.backgroundColor=[UIColor brownColor].CGColor;
    layer.bounds=CGRectMake(0, 0, 200, 150);
    layer.anchorPoint=CGPointZero;
    layer.position=CGPointMake(0, 300);
    layer.cornerRadius=20;
    layer.shadowColor=[UIColor blackColor].CGColor;
    layer.shadowOffset=CGSizeMake(10, 20);
    layer.shadowOpacity=0.6;
    
    [layer setNeedsDisplay];
    //3.添加layer
    [self.view.layer addSublayer:layer];
    
    //方法2 设置代理
    //1.创建自定义的layer
    CALayer *layer2=[CALayer layer];
    //2.设置layer的属性
    layer2.backgroundColor=[UIColor brownColor].CGColor;
    layer2.bounds=CGRectMake(0, 0, 200, 150);
    layer2.anchorPoint=CGPointZero;
    layer2.position=CGPointMake(300, 150);
    layer2.cornerRadius=20;
    layer2.shadowColor=[UIColor blackColor].CGColor;
    layer2.shadowOffset=CGSizeMake(10, 20);
    layer2.shadowOpacity=0.6;
    
    //设置代理
    layer2.delegate=self;
    [layer2 setNeedsDisplay];
    //3.添加layer
    [self.view.layer addSublayer:layer2];
}

//代理
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    //1.绘制图形
    //画一个圆
    CGContextAddEllipseInRect(ctx, CGRectMake(50, 50, 100, 100));
    //设置属性（颜色）
    //    [[UIColor yellowColor]set];
    CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
    
    //2.渲染
    CGContextFillPath(ctx);
}

# pragma mark - CALayer的transform属性
- (void)setTransform{
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

- (void)startAnim:(BOOL)isCoverEye{
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
