//
//  ViewController.m
//  CALayer_transform
//
//  Created by Zachary on 16/9/2.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import "ViewController.h"
#define angle2Radian(angle)  ((angle)/180.0*M_PI)

typedef NS_ENUM(NSInteger, AnimationType) {
    //以下是枚举成员
    BaseAnimation = 1,
    KeyFrameAnimation_Value = 1<<1,
    KeyFrameAnimation_Path = 1<<2,
    KeyFrameAnimation_shake = 1<<3,
    Transition = 1<<4,
    AnimationGroup = 1<<5,
    ViewAnimation = 1<<6
};

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UIView *leftArm;


@property (nonatomic, weak) IBOutlet UIView *leftHand;


@property (nonatomic, weak) IBOutlet UIButton *button;

@property (nonatomic, weak) IBOutlet UIButton *button2;

@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (nonatomic, assign) CGFloat offsetLX;

@property (nonatomic, assign) CGFloat offsetLY;

// 动画相关参数
@property(nonatomic,strong)CALayer *myLayer;
@property(nonatomic,assign)AnimationType animationType;
@property(nonatomic,assign) int index;



@end

@implementation ViewController

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
    
    //Animation 相关的初始化
    _animationType = BaseAnimation|KeyFrameAnimation_shake|ViewAnimation;
    [self initAnimationWithType:_animationType];
}

#pragma mark - Animation初始化
- (void)initAnimationWithType:(NSInteger)type{
    _animationType = type;
    for (NSInteger animationType = 1; animationType<(ViewAnimation<<1); animationType = animationType<<1) {
        if (type & animationType) {
            [self startAnimationInitialWithType:animationType];
        }
    }
}

- (void)startAnimationInitialWithType:(NSInteger)type{
    
    switch (type) {
        case BaseAnimation:{
            CALayer *myLayer=[CALayer layer];
            myLayer.bounds=CGRectMake(0, 0, 50, 80);
            myLayer.backgroundColor=[UIColor yellowColor].CGColor;
            myLayer.position=CGPointMake(50, 50);
            myLayer.anchorPoint=CGPointMake(0, 0);
            myLayer.cornerRadius=20;
            //添加layer
            [self.view.layer addSublayer:myLayer];
            self.myLayer=myLayer;
        }
            break;
        case Transition:
            _index = 1;
            break;
        default:
            break;
    }
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
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
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
    
    //Transition动画需要的点击事件
    if (_animationType&Transition) {
        self.index--;
        if (self.index<1) {
            self.index=7;
        }
        self.iconView.image=[UIImage imageNamed: [NSString stringWithFormat:@"%d.jpg",self.index]];
        
        //创建核心动画
        CATransition *ca=[CATransition animation];
        //告诉要执行什么动画
        //设置过度效果
        ca.type=@"cube";
        //设置动画的过度方向（向左）
        ca.subtype=kCATransitionFromLeft;
        //设置动画的时间
        ca.duration=2.0;
        //添加动画
        [self.iconView.layer addAnimation:ca forKey:nil];
    }
}

- (void)button2Pressed{
    _button2.selected = !_button2.selected;
    [self startAnim2:_button2.selected];
    
    //Transition动画需要的点击事件
    if (_animationType&Transition) {
        self.index++;
        if (self.index>7) {
            self.index=1;
        }
        self.iconView.image=[UIImage imageNamed: [NSString stringWithFormat:@"%d.jpg",self.index]];
        
        //1.创建核心动画
        CATransition *ca=[CATransition animation];
        
        //1.1告诉要执行什么动画
        //1.2设置过度效果
        ca.type=@"cube";
        //1.3设置动画的过度方向（向右）
        ca.subtype=kCATransitionFromRight;
        //1.4设置动画的时间
        ca.duration=2.0;
        //1.5设置动画的起点
        ca.startProgress=0.5;
        //1.6设置动画的终点
        //    ca.endProgress=0.5;
        
        //2.添加动画
        [self.iconView.layer addAnimation:ca forKey:nil];
        
    }
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

# pragma mark - 触摸操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //图层动画触摸事件
    [self layerAnimation];
    //核心动画触摸事件
    [self coreAnimationWithType:_animationType];
}

- (void)layerAnimation{
    //通过uiview设置（2D效果）
    //    self.iconView.transform=CGAffineTransformMakeTranslation(0, -100);
    //通过layer来设置（3D效果,x，y，z三个方向）
    //    self.iconView.layer.transform=CATransform3DMakeTranslation(100, 20, 0);
    CATransform3D t3d = CATransform3DMakeTranslation(100, 20, 0);
    self.iconView.layer.transform = CATransform3DRotate(t3d, M_PI_4, 1, 1, 0.5);
}

- (void)coreAnimationWithType:(NSInteger)type{
    for (NSInteger animationType = 1; animationType<(ViewAnimation<<1); animationType = animationType<<1) {
        if (type & animationType) {
            [self startCoreAnimationWithType:animationType];
        }
    }
}

- (void)startCoreAnimationWithType:(NSInteger)type{
    switch (type) {
        case BaseAnimation:{
            //1.创建核心动画
            //    CABasicAnimation *anima=[CABasicAnimation animationWithKeyPath:<#(NSString *)#>]
            CABasicAnimation *anima=[CABasicAnimation animation];
            
            //1.1告诉系统要执行什么样的动画
            anima.keyPath=@"position";
            //设置通过动画，将layer从哪儿移动到哪儿
            anima.fromValue=[NSValue valueWithCGPoint:CGPointMake(0, 0)];
            anima.toValue=[NSValue valueWithCGPoint:CGPointMake(200, 300)];
            
            //1.2设置动画执行完毕之后不删除动画
            anima.removedOnCompletion=NO;
            //1.3设置保存动画的最新状态
            anima.fillMode=kCAFillModeForwards;
            //2.添加核心动画到layer
            [self.myLayer addAnimation:anima forKey:nil];
        }
            break;
        case KeyFrameAnimation_Value:{
            //1.创建核心动画
            CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
            //平移
            keyAnima.keyPath=@"position";
            //1.1告诉系统要执行什么动画
            NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(100, 100)];
            NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(200, 100)];
            NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(200, 200)];
            NSValue *value4=[NSValue valueWithCGPoint:CGPointMake(100, 200)];
            NSValue *value5=[NSValue valueWithCGPoint:CGPointMake(100, 100)];
            keyAnima.values=@[value1,value2,value3,value4,value5];
            //1.2设置动画执行完毕后，不删除动画
            keyAnima.removedOnCompletion=NO;
            //1.3设置保存动画的最新状态
            keyAnima.fillMode=kCAFillModeForwards;
            //1.4设置动画执行的时间
            keyAnima.duration=4.0;
            //1.5设置动画的节奏
            keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            //设置代理，开始—结束
            keyAnima.delegate=self;
            //2.添加核心动画
            [self.customView.layer addAnimation:keyAnima forKey:nil];
        }
            break;
        case KeyFrameAnimation_Path:{
            //1.创建核心动画
            CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
            //平移
            keyAnima.keyPath=@"position";
            //1.1告诉系统要执行什么动画
            //创建一条路径
            CGMutablePathRef path=CGPathCreateMutable();
            //设置一个圆的路径
            CGPathAddEllipseInRect(path, NULL, CGRectMake(150, 100, 100, 100));
            keyAnima.path=path;
            
            //有create就一定要有release
            CGPathRelease(path);
            //1.2设置动画执行完毕后，不删除动画
            keyAnima.removedOnCompletion=NO;
            //1.3设置保存动画的最新状态
            keyAnima.fillMode=kCAFillModeForwards;
            //1.4设置动画执行的时间
            keyAnima.duration=5.0;
            //1.5设置动画的节奏
            keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            //设置代理，开始—结束
            keyAnima.delegate=self;
            //2.添加核心动画
            [self.customView.layer addAnimation:keyAnima forKey:@"wendingding"];
        }
            break;
        case KeyFrameAnimation_shake:{
            //1.创建核心动画
            CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
            keyAnima.keyPath=@"transform.rotation";
            //设置动画时间
            keyAnima.duration=0.1;
            //设置图标抖动弧度
            //把度数转换为弧度  度数/180*M_PI
            keyAnima.values=@[@(-angle2Radian(4)),@(angle2Radian(4)),@(-angle2Radian(4))];
            //设置动画的重复次数(设置为最大值)
            keyAnima.repeatCount=MAXFLOAT;
            
            keyAnima.fillMode=kCAFillModeForwards;
            keyAnima.removedOnCompletion=NO;
            //2.添加动画
            [self.iconView.layer addAnimation:keyAnima forKey:nil];
        }
            break;
        case AnimationGroup:{
            CABasicAnimation *a1 = [CABasicAnimation animation];
            a1.keyPath = @"transform.translation.y";
            a1.toValue = @(100);
            // 缩放动画
            CABasicAnimation *a2 = [CABasicAnimation animation];
            a2.keyPath = @"transform.scale";
            a2.toValue = @(0.0);
            // 旋转动画
            CABasicAnimation *a3 = [CABasicAnimation animation];
            a3.keyPath = @"transform.rotation";
            a3.toValue = @(M_PI_2);
            // 组动画
            CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
            
            groupAnima.animations = @[a1, a2, a3];
            
            //设置组动画的时间
            groupAnima.duration = 2;
            groupAnima.fillMode = kCAFillModeForwards;
            groupAnima.removedOnCompletion = NO;
            
            [self.iconView.layer addAnimation:groupAnima forKey:nil];
        }
            break;
        case ViewAnimation:{
            //打印动画块的位置
            NSLog(@"动画执行之前的位置：%@",NSStringFromCGPoint(self.customView.center));
            
            //首尾式动画
            [UIView beginAnimations:nil context:nil];
            //执行动画
            //设置动画执行时间
            [UIView setAnimationDuration:2.0];
            //设置代理
            [UIView setAnimationDelegate:self];
            //设置动画执行完毕调用的事件
            [UIView setAnimationDidStopSelector:@selector(didStopAnimation)];
            self.customView.center=CGPointMake(200, 300);
            [UIView commitAnimations];
        }
        default:
            break;
    }

}

# pragma mark - 动画代理
-(void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"开始执行动画");
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //动画执行完毕，打印执行完毕后的position值
    NSString *str=NSStringFromCGPoint(self.myLayer.position);
    NSLog(@"执行后：%@",str);
}

-(void)didStopAnimation{
    NSLog(@"动画执行完毕");
    //打印动画块的位置
    NSLog(@"动画执行之后的位置：%@",NSStringFromCGPoint(self.customView.center));
}

@end
