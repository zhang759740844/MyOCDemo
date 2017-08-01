//
//  SimpleReusableView.m
//  UICollectionViewDemo
//
//  Created by Zachary Zhang on 2017/7/28.
//  Copyright © 2017年 Zachary Zhang. All rights reserved.
//

#import "SimpleReusableView.h"

@interface SimpleReusableView()

@property (nonatomic,strong) UILabel *label;

@end


@implementation SimpleReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _label = [[UILabel alloc] initWithFrame:self.frame];
    _label.backgroundColor = [UIColor purpleColor];
    [self addSubview:_label];
    self.backgroundColor = [UIColor grayColor];
    return self;
}

- (void)layoutSubviews {
    [_label sizeToFit];
    _label.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

-(void)prepareForReuse {
    [super prepareForReuse];
    _label.text = @"";
}

- (void)refreshData {
    [_label setText:_num];
    [self setNeedsLayout];
}

@end
