//
//  SimpleReusableView.h
//  UICollectionViewDemo
//
//  Created by Zachary Zhang on 2017/7/28.
//  Copyright © 2017年 Zachary Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleReusableView : UICollectionReusableView

@property (nonatomic,strong) NSString *num;

- (void)refreshData;

@end
