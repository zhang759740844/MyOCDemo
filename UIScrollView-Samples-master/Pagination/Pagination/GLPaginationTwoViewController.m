//
//  GLPaginationTwoViewController.m
//  Pagination
//
//  Created by Allen Hsu on 12/14/14.
//  Copyright (c) 2014 Glow, Inc. All rights reserved.
//

#import "GLPaginationTwoViewController.h"
#import "Utils.h"

#define BUBBLE_DIAMETER     60.0
#define BUBBLE_PADDING      10.0

@interface GLPaginationTwoViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidthConstraint;
@end

@implementation GLPaginationTwoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupPages];
}

- (void)setupPages
{
    int totalNum = 100;
    
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    CGFloat x = (self.scrollView.frame.size.width - BUBBLE_DIAMETER) / 2.0;
    CGFloat y = (self.scrollView.frame.size.height - BUBBLE_DIAMETER) / 2.0;
    for (int i = 0; i < totalNum; ++i) {
        CGRect frame = CGRectMake(x, y, BUBBLE_DIAMETER, BUBBLE_DIAMETER);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"#%d", i];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = UIColorFromRGB(0x5a62d2);
        label.layer.cornerRadius = frame.size.width / 2.0;
        label.layer.masksToBounds = YES;
        label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:label];
        x += BUBBLE_DIAMETER + BUBBLE_PADDING;
    }
    self.contentWidthConstraint.constant = x + (self.scrollView.frame.size.width) / 2.0;
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
}


//在停止滚动后，拿到ScrollView的contentOffset值，得到最接近的page的contentOffset的值，直接设置。
//缺点是必须要在滚动停止后才能拿到contentOffset，所以只能在已经停止后进行滚动。
- (void)snapToNearestItem
{
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:self.scrollView.contentOffset];
    [self.scrollView setContentOffset:targetOffset animated:YES];

        //这里没法用UIView的动画属性，在设置了contentOffset后，ScrollView立刻跳到指定位置。
//    self.scrollView.contentOffset = targetOffset;
//    [UIView animateWithDuration:5 animations:^{
//        [self.view layoutIfNeeded];
//    }];
}

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    CGFloat pageSize = BUBBLE_DIAMETER + BUBBLE_PADDING;
    NSInteger page = roundf(offset.x / pageSize);
    CGFloat targetX = pageSize * page;
    return CGPointMake(targetX, offset.y);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self snapToNearestItem];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self snapToNearestItem];
}

@end
