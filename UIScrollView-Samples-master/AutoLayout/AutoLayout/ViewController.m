//
//  ViewController.m
//  AutoLayout
//
//  Created by Allen Hsu on 11/17/14.
//  Copyright (c) 2014 Glow, Inc. All rights reserved.
//

#import "ViewController.h"
#import "PureLayout.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidthConstraint;
@property (assign, nonatomic) int pageBeforeRotation;
@property (assign, nonatomic) int totalPages;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self generateRandomPages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//屏幕旋转时调整page的位置
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    int page = roundf(self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
    page = MIN(MAX(page, 0), self.totalPages);
    self.pageBeforeRotation = page;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * self.pageBeforeRotation, 0.0);
}

- (IBAction)didClickRegenerate:(id)sender {
    [self generateRandomPages];
}

- (void)generateRandomPages
{
    int pages = arc4random() % 10 + 10;
    [self setupPages:pages];
}

- (void)setupPages:(int)pages
{
    self.totalPages = pages;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.alpha = 0.0;
    } completion:^(BOOL finished) {
        NSArray *subviews = self.contentView.subviews;
        for (UIView *view in subviews) {
            [view removeFromSuperview];
        }
        //  设置contentView的宽度约束
        //第一种做法是删除原来的约束，再添加新的约束
//        [self.contentWidthConstraint autoRemove];
//        self.contentWidthConstraint = [self.contentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.scrollView withMultiplier:pages];
        //第二种方式是设置constant，由于在xib中设置了约束： ScrollView.frame.size.width = contentView.frame.size.width + constant
        //由于scrollview的bounds已经确定，
        //所以constant要设置成负数才能让contentView的宽度达到理想值
        //这里讲constant设置成-2000，那么contentView，在此例中也就是contentsize的宽度就是ScrollView的宽度+2000
        self.contentWidthConstraint.constant =-2000;
        UILabel *prevLabel = nil;
        NSLog(@"%f",self.contentWidthConstraint.constant);
        NSLog(@"%f",self.scrollView.frame.size.width);
       
//        for (int i = 0; i<6;i++){
        for (int i = 0; i<(-self.contentWidthConstraint.constant)/self.scrollView.frame.size.width;i++){
//        for (int i = 0; i < pages; ++i) {
            UILabel *pageLabel = [[UILabel alloc] initWithFrame:self.scrollView.bounds];
            pageLabel.text = [NSString stringWithFormat:@"Page %d of %d", i + 1, pages];
            pageLabel.font = [UIFont fontWithName:@"Georgia-Italic" size:18.0];
            pageLabel.textAlignment = NSTextAlignmentCenter;
            
            [self.contentView addSubview:pageLabel];
            
            [pageLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.scrollView];
            [pageLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
            [pageLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
            
            if (!prevLabel) {
                // Align to contentView
                [pageLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            } else {
                // Align to prev label
                [pageLabel autoConstrainAttribute:ALAttributeLeading toAttribute:ALAttributeTrailing ofView:prevLabel];
            }
            
            if (i == pages - 1) {
                // Last page
                [pageLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
            }
            
            prevLabel = pageLabel;
        }
        
        self.scrollView.contentOffset = CGPointZero;
    
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.alpha = 1.0;
        }];
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
