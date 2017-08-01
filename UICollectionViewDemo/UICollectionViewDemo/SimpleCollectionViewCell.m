//
//  SimpleCollectionViewCell.m
//  UICollectionViewDemo
//
//  Created by Zachary Zhang on 2017/7/27.
//  Copyright © 2017年 Zachary Zhang. All rights reserved.
//

#import "SimpleCollectionViewCell.h"

@interface SimpleCollectionViewCell()

@property (nonatomic,strong) UILabel *label;

@end

@implementation SimpleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_label];
    self.backgroundView= [[UIView alloc] init];
    self.backgroundView.backgroundColor = [UIColor greenColor];
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.num = @"";
}

- (void)layoutSubviews {
    // 这个 super 方法也必须要调用，否则 self 的 frame 变化了，但是 contentView 的 frame 却没有变化，导致 self.contentView.center 不对
    [super layoutSubviews];
    [self.label sizeToFit];
    self.label.center = self.contentView.center;
}

- (void)refreshData {
    _label.text = _num;
    [self setNeedsLayout];
}

@end
