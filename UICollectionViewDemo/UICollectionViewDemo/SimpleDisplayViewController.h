//
//  SimpleDisplayViewController.h
//  UICollectionViewDemo
//
//  Created by Zachary Zhang on 2017/7/27.
//  Copyright © 2017年 Zachary Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NormalLayout,
    CustomLayout,
    ShowPicLayout,
} LayoutTypes;

@interface SimpleDisplayViewController : UIViewController

@property (nonatomic,assign) LayoutTypes layoutType;

@end
