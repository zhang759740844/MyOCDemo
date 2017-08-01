//
//  CustomCollectionViewController.m
//  UICollectionViewDemo
//
//  Created by Zachary Zhang on 2017/8/1.
//  Copyright © 2017年 Zachary Zhang. All rights reserved.
//

#import "CustomCollectionViewController.h"
#import "CustomCircleLayout.h"
#import "SimpleCollectionViewFlowLayout.h"
#import "SimpleCollectionViewCell.h"

static NSString *CellIdentifier = @"Cell Identifer";

@interface CustomCollectionViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) CustomCircleLayout *circleLayout;
@property (nonatomic, strong) SimpleCollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, strong) UISegmentedControl *layoutChangeSegmentedControl;

@end

@implementation CustomCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _circleLayout = [[CustomCircleLayout alloc] init];
    _flowLayout = [[SimpleCollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_circleLayout];
    [self.collectionView registerClass:[SimpleCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    self.cellCount = 12;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteItem)];
    
    self.layoutChangeSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Circle", @"Flow"]];
    self.layoutChangeSegmentedControl.selectedSegmentIndex = 0;
    [self.layoutChangeSegmentedControl addTarget:self action:@selector(layoutChangeSegmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.layoutChangeSegmentedControl;
    
    
    //collectionView不像tableView可以设置setEditing属性切换是否能够编辑，需要声明长按手势在 viewDidload 方法中
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    [self.collectionView addGestureRecognizer:longGesture];
}

- (void)addItem {
    [self.collectionView performBatchUpdates:^{
        self.cellCount++;
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:4 inSection:0]]];
    } completion:nil];
}

- (void)deleteItem {
    [self.collectionView performBatchUpdates:^{
        self.cellCount--;
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:4 inSection:0]]];
    } completion:nil];
    
}

- (void)layoutChangeSegmentedControlDidChangeValue:(id)sender {
    if (self.collectionView.collectionViewLayout == _circleLayout) {
        [_flowLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:_flowLayout animated:YES];
        [self.collectionView performBatchUpdates:^{
            self.cellCount--;
            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
        } completion:nil];
    } else {
        [_circleLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:_circleLayout animated:YES];
        [self.collectionView reloadData];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SimpleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.num = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
    [cell refreshData];
    
    return cell;
}

#pragma mark - 高亮
// 允许选中时，高亮
-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
// 高亮完成后回调
// 放大缩小效果
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:1 animations:^{
        selectedCell.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
    }];
}
// 由高亮转成非高亮完成时的回调
-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:1 animations:^{
        selectedCell.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }];
}

#pragma mark - 移动
//返回YES允许其item移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//移动item时回调
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
}


//再实现手势操作
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            if (indexPath == nil) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [self.collectionView endInteractiveMovement];
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}


@end
