//
//  MainViewController.m
//  UICollectionViewDemo
//
//  Created by Zachary Zhang on 2017/7/27.
//  Copyright © 2017年 Zachary Zhang. All rights reserved.
//

#import "CustomCollectionViewController.h"
#import "MainViewController.h"
#import "SimpleDisplayViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    // NormalLayout
    UIButton *normalBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    normalBtn.layer.borderWidth = 2;
    [normalBtn setTitle:@"jump to normal Display" forState:UIControlStateNormal];
    normalBtn.bounds = CGRectMake(0, 0, [normalBtn sizeThatFits:CGSizeZero].width, 50);
    normalBtn.backgroundColor = [UIColor redColor];
    normalBtn.center = CGPointMake(self.view.center.x, 150);
    [normalBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [normalBtn addTarget:self action:@selector(normalBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:normalBtn];
    // CustomFlowLayout
    UIButton *customBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    customBtn.layer.borderWidth = 2;
    [customBtn setTitle:@"jump to custom Display" forState:UIControlStateNormal];
    customBtn.bounds = CGRectMake(0, 0, [customBtn sizeThatFits:CGSizeZero].width, 50);
    customBtn.backgroundColor = [UIColor redColor];
    customBtn.center = CGPointMake(self.view.center.x, 250);
    [customBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [customBtn addTarget:self action:@selector(customBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:customBtn];
    // PicLayout
    UIButton *picBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    picBtn.layer.borderWidth = 2;
    [picBtn setTitle:@"jump to pic Display" forState:UIControlStateNormal];
    [picBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    picBtn.backgroundColor = [UIColor redColor];
    picBtn.bounds = CGRectMake(0, 0, [picBtn sizeThatFits:CGSizeZero].width, 50);
    picBtn.center = CGPointMake(self.view.frame.size.width/2, 350);
    [picBtn addTarget:self action:@selector(picBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:picBtn];
    // CustomLayout
    UIButton *customLayoutBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    customLayoutBtn.layer.borderWidth = 2;
    customLayoutBtn.backgroundColor = [UIColor redColor];
    [customLayoutBtn setTitle:@"jump to custom layout display" forState:UIControlStateNormal];
    [customLayoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    customLayoutBtn.bounds = CGRectMake(0, 0, [customLayoutBtn sizeThatFits:CGSizeZero].width, 50);
    customLayoutBtn.center = CGPointMake(self.view.bounds.size.width/2, 450);
    [customLayoutBtn addTarget:self action:@selector(customLayoutBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:customLayoutBtn]; 
}

- (void)normalBtnClicked {
    SimpleDisplayViewController *simpleDisplayViewController = [[SimpleDisplayViewController alloc] init];
    simpleDisplayViewController.layoutType = NormalLayout;
    [self.navigationController pushViewController:simpleDisplayViewController animated:YES];
}

- (void)customBtnClicked {
    SimpleDisplayViewController *simpleDisplayViewController = [[SimpleDisplayViewController alloc] init];
    simpleDisplayViewController.layoutType = CustomLayout;
    [self.navigationController pushViewController:simpleDisplayViewController animated:YES];
}

- (void)picBtnClicked {
    SimpleDisplayViewController *simpleDisplayViewController = [[SimpleDisplayViewController alloc] init];
    simpleDisplayViewController.layoutType = ShowPicLayout;
    [self.navigationController pushViewController:simpleDisplayViewController animated:YES];
}

- (void)customLayoutBtnClicked {
    CustomCollectionViewController *customCollectionViewControllr = [[CustomCollectionViewController alloc] init];
    [self.navigationController pushViewController:customCollectionViewControllr animated:YES];
}
@end
