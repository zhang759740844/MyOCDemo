//
//  ViewController.m
//  Reuse
//
//  Created by Allen Hsu on 12/14/14.
//  Copyright (c) 2014 Glow, Inc. All rights reserved.
//

#import "ViewController.h"
#import "PureLayout.h"
#import "GLReusableViewController.h"

#define TOTAL_PAGES     10

@interface ViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidthConstraint;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIScrollView *navScrollView;
@property (weak, nonatomic) IBOutlet UIView *navContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navContentWidthConstraint;

@property (strong, nonatomic) NSNumber *currentPage;

@property (strong, nonatomic) NSMutableArray *reusableViewControllers;
@property (strong, nonatomic) NSMutableArray *visibleViewControllers;

@end

@implementation ViewController

- (NSMutableArray *)reusableViewControllers
{
    if (!_reusableViewControllers) {
        _reusableViewControllers = [NSMutableArray array];
    }
    return _reusableViewControllers;
}

- (NSMutableArray *)visibleViewControllers
{
    if (!_visibleViewControllers) {
        _visibleViewControllers = [NSMutableArray array];
    }
    return _visibleViewControllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPages];
    [self loadPage:0];
}

- (void)setupPages
{
    // 为根据页面数为两个ScrollView添加宽度约束
    [self.contentWidthConstraint autoRemove];
    self.contentWidthConstraint = [self.contentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.scrollView withMultiplier:TOTAL_PAGES];
    [self.navContentWidthConstraint autoRemove];
    self.navContentWidthConstraint = [self.navContentView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.navScrollView withMultiplier:TOTAL_PAGES];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    // 上部导航栏ScrollView的渐隐效果
    CAGradientLayer *l = [CAGradientLayer layer];
    l.frame = self.titleView.bounds;
    l.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    l.startPoint = CGPointMake(0.0f, 0.5f);
    l.endPoint = CGPointMake(1.0f, 0.5f);
    self.titleView.layer.mask = l;
    
    // 为navigation栏的ScrollView内的viewcontroller添加宽度约束
    CGFloat x = 0;
    for (int i = 0; i < TOTAL_PAGES; ++i) {
        CGRect frame = CGRectMake(x, 0.0, self.navScrollView.frame.size.width, self.navScrollView.frame.size.height - 10.0);    //-10是为了给page Control留空间
        UILabel *title = [[UILabel alloc] initWithFrame:frame];
        title.text = [NSString stringWithFormat:@"#%d", i];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor blackColor];
        title.font = [UIFont boldSystemFontOfSize:14.0];
        [self.navContentView addSubview:title];
        x += self.navScrollView.frame.size.width;
    }
    
    self.pageControl.numberOfPages = TOTAL_PAGES;
}

- (void)setCurrentPage:(NSNumber *)currentPage
{
    if (_currentPage != currentPage) {
        _currentPage = currentPage;
        self.pageControl.currentPage = [currentPage integerValue];
    }
}

- (void)loadPage:(NSInteger)page
{
    //当要显示的页面就是当前页时，直接return，不修改
    if (self.currentPage && page == [self.currentPage integerValue]) {
        return;
    }

    self.currentPage = @(page);
    //为了做两件事
    //  1.找到不再显示的viewcontroller的page，将其添加到reuseableViewControllers，用来复用
    //  2.找到显示的viewcontroller的page，将其添加到visibleViewControllers里。
    //局部变量pagesToLoad用来存储visibleViewControllers中应该保存的Controller的page，通过和当前visibleviewcontrollers中的page对比，找到`不再显示的`和`将要显示的`viewcontroller的page
    NSMutableArray *pagesToLoad = [@[@(page), @(page - 1), @(page + 1)] mutableCopy];
    
    //将不再显示的viewcontroller放入vcsToEnqueue数组，将已经显示的从pagesToload中剔除，只剩下将要显示的。
    NSMutableArray *vcsToEnqueue = [NSMutableArray array];
    for (GLReusableViewController *vc in self.visibleViewControllers) {
        if (!vc.page || ![pagesToLoad containsObject:vc.page]) {    //这里的!page不代表page为0，而是page为空。因为page是NSNumber类型。
            [vcsToEnqueue addObject:vc];
        } else{
            [pagesToLoad removeObject:vc.page];
        }
    }
    
    //遍历vcsToEnqueue,将其中的vc移除，并且enqueue重用，将view添加到reusableVIewControllers数组中。
    for (GLReusableViewController *vc in vcsToEnqueue) {
        [vc.view removeFromSuperview];
        [self.visibleViewControllers removeObject:vc];
        [self enqueueReusableViewController:vc];
    }
    //遍历pagesToLoad，添加要load的view到visibleViewController中，添加view到ScrollView中
    for (NSNumber *page in pagesToLoad) {
        [self addViewControllerForPage:[page integerValue]];
    }
}

- (void)enqueueReusableViewController:(GLReusableViewController *)viewController
{
    [self.reusableViewControllers addObject:viewController];
}

- (GLReusableViewController *)dequeueReusableViewController
{
    static int numberOfInstance = 0;
    GLReusableViewController *vc = [self.reusableViewControllers firstObject];
    if (vc) {
        [self.reusableViewControllers removeObject:vc];
    } else {
        vc = [GLReusableViewController viewControllerFromStoryboard];
        vc.numberOfInstance = numberOfInstance;
        numberOfInstance++;
        //在viewController中添加controller
        [vc willMoveToParentViewController:self];
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
    }
    return vc;
}

- (void)addViewControllerForPage:(NSInteger)page
{
    if (page < 0 || page >= TOTAL_PAGES) {
        return;
    }
    GLReusableViewController *vc = [self dequeueReusableViewController];
    vc.page = @(page);
    vc.view.frame = CGRectMake(self.scrollView.frame.size.width * page, 0.0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.contentView addSubview:vc.view];
    [self.visibleViewControllers addObject:vc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 这是设置的入口，在滑动的时候调用
// 计算即将转到的page，然后使用loadPage加载
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        //根据contentScrollView的位置，来设置navScrollView的位置
        CGFloat navX = scrollView.contentOffset.x / scrollView.frame.size.width * self.navScrollView.frame.size.width;
        self.navScrollView.contentOffset = CGPointMake(navX, 0.0);
        NSInteger page = roundf(scrollView.contentOffset.x / scrollView.frame.size.width);
        page = MAX(page, 0);
        page = MIN(page, TOTAL_PAGES - 1);
        [self loadPage:page];
        NSLog(@"content");
    }
    else{
        NSLog(@"navigation");
    }
}

@end
