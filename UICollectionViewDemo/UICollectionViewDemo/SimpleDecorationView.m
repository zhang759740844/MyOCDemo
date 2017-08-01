//
//  SimpleDecorationView.m
//  UICollectionViewDemo
//
//  Created by Zachary Zhang on 2017/7/30.
//  Copyright © 2017年 Zachary Zhang. All rights reserved.
//

#import "SimpleDecorationView.h"

@interface SimpleDecorationView()

@property (nonatomic, strong) UIView *decorationView;

@end
@implementation SimpleDecorationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    _decorationView = [[UIView alloc] initWithFrame:frame];
    _decorationView.backgroundColor = [UIColor blueColor];
    [self addSubview:_decorationView];
    return self;
}

- (void)layoutSubviews {
    _decorationView.frame = self.bounds;
}
@end
