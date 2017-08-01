//
//  SimpleDisplayViewController.m
//  UICollectionViewDemo
//
//  Created by Zachary Zhang on 2017/7/27.
//  Copyright © 2017年 Zachary Zhang. All rights reserved.
//

#import "SimpleDisplayViewController.h"
#import "SimpleCollectionViewCell.h"
#import "SimpleReusableView.h"
#import "SimpleCollectionViewFlowLayout.h"
#import "PicFlowLayout.h"


static NSString *SIMPLESUPPLEMENTARYIDENTIFIER = @"Simple Supplementary Identifier";
static NSString *SIMPLECELLIDENTIFIER = @"Simple Cell Identifier";

@interface SimpleDisplayViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,assign) NSUInteger count;

@property (nonatomic,assign) NSUInteger sectionCount;

@end

@implementation SimpleDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _count = 30;
    _sectionCount = 5;
    // 设置 flowLayout
    UICollectionViewFlowLayout *flowLayout;
    switch (_layoutType) {
        case NormalLayout:
            flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.minimumInteritemSpacing = 20;
            flowLayout.minimumLineSpacing = 40;
            flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
            flowLayout.itemSize = CGSizeMake(50, 50);
            flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 30);
            break;
        case CustomLayout:
            flowLayout = [[SimpleCollectionViewFlowLayout alloc] init];
            flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 30);
            break;
        case ShowPicLayout:
            flowLayout = [[PicFlowLayout alloc] init];
            flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 30);
            break;
        default:
            break;
    }
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    // 添加 collectionView，记得要设置 delegate 和 dataSource 的代理对象
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_collectionView];
    
    // 注册 cell
    [_collectionView registerClass:[SimpleCollectionViewCell class] forCellWithReuseIdentifier:SIMPLECELLIDENTIFIER];
    [_collectionView registerClass:[SimpleReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SIMPLESUPPLEMENTARYIDENTIFIER];
    
    self.navigationItem.title = @"Simple Display";
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    self.navigationItem.rightBarButtonItem = btnItem;
}

#pragma mark - Private Methods
- (void)addItem:(id)sender {
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:2 inSection:0]]];
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:5 inSection:0]]];
    } completion:nil];
}

#pragma mark - CollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 取消选中
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    // 获取当前点击的 cell
    SimpleCollectionViewCell *cell = (SimpleCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.num = @"be selected";
    [cell refreshData];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:((SimpleCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath]).num];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(10, 10);
    }
    return CGSizeMake(50, 50);
}

#pragma mark - CollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _sectionCount;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    SimpleReusableView *reuseableView = (SimpleReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SIMPLESUPPLEMENTARYIDENTIFIER forIndexPath:indexPath];
    reuseableView.num = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    [reuseableView refreshData];
    return reuseableView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SimpleCollectionViewCell *cell = (SimpleCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:SIMPLECELLIDENTIFIER forIndexPath:indexPath];
    cell.num = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
    [cell refreshData];
    return cell;
}

@end
