//
//  SimpleCollectionViewCell.h
//  UICollectionViewDemo
//
//  Created by Zachary Zhang on 2017/7/27.
//  Copyright © 2017年 Zachary Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleCollectionViewCell : UICollectionViewCell

@property (nonatomic,copy) NSString *num;

- (void)refreshData;


@end
