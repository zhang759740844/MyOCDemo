//
//  CustomCircleLayout.m
//  UICollectionViewDemo
//
//  Created by Zachary Zhang on 2017/8/1.
//  Copyright © 2017年 Zachary Zhang. All rights reserved.
//

#import "CustomCircleLayout.h"

@interface CustomCircleLayout ()

@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) NSInteger radius;

@property (nonatomic, strong) NSMutableSet *insertedRowSet;
@property (nonatomic, strong) NSMutableSet *deletedRowSet;

@end
@implementation CustomCircleLayout

- (void)prepareLayout {
    [super prepareLayout];
    CGSize size = self.collectionView.bounds.size;
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    _center = CGPointMake(size.width/2, size.height/2);
    _radius = size.width/2.5;
    
    _insertedRowSet = [NSMutableSet set];
    _deletedRowSet = [NSMutableSet set];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attrs = [NSMutableArray array];
    for (int i = 0; i < self.cellCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attrs addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attrs; 
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.size =  CGSizeMake(70, 70);
    attrs.center = CGPointMake(self.center.x +self.radius * cosf(2 * indexPath.item * M_PI / self.cellCount -M_PI_2), self.center.y +self.radius * sinf(2 * indexPath.item * M_PI /self.cellCount - M_PI_2));
    attrs.transform3D = CATransform3DMakeRotation(2 * M_PI *indexPath.item / self.cellCount, 0, 0, 1);
    return attrs;
}

#pragma mark - Animation
//- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
//    [super prepareForCollectionViewUpdates:updateItems];
//    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj.updateAction == UICollectionUpdateActionInsert) {
//            [self.insertedRowSet addObject:@(obj.indexPathAfterUpdate.item)];
//        } else if (obj.updateAction == UICollectionUpdateActionDelete) {
//            [self.deletedRowSet addObject:@(obj.indexPathBeforeUpdate.item)];
//        }
//    }];
//}
//
//- (void)finalizeCollectionViewUpdates {
//    [super finalizeCollectionViewUpdates];
//    
//    [self.insertedRowSet removeAllObjects];
//    [self.deletedRowSet removeAllObjects];
//}
//
//- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
//    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
//    
//    if ([self.insertedRowSet containsObject:@(itemIndexPath.item)]) {
//        attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//        attributes.alpha = 0;
//        attributes.center = self.center;
//        return attributes;
//    }
//    return attributes;
//}
//
//- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
//    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
//    
//    if ([self.insertedRowSet containsObject:@(itemIndexPath.item)]) {
//        attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//        attributes.alpha = 0;
//        attributes.center = self.center;
//        return attributes;
//    }
//    return attributes;
//    
//}

























@end
