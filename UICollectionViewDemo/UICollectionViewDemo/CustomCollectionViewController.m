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
    } else {
        [_circleLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:_circleLayout animated:YES];
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



@end
