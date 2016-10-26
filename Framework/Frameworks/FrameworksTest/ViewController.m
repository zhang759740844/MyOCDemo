//
//  ViewController.m
//  FrameworksTest
//
//  Created by Zachary on 2016/10/24.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import "ViewController.h"
#import "PrintString.h"
//#import "DynamicWithStatic/SVProgress.h"
//#import "DynamicWithDynamic/SVProgress.h"
//#import "StaticWithStatic.h"
@interface ViewController ()
@property (nonatomic,strong) IBOutlet UIImageView *imgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [PrintString printString];
    UIImage *image = [PrintString getImage];
    [_imgView setImage:image];
//    [SVProgress getBlock]();
}



@end
