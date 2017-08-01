//
//  SimpleCollectionViewFlowLayout.m
//  UICollectionViewDemo
//
//  Created by Zachary Zhang on 2017/7/30.
//  Copyright © 2017年 Zachary Zhang. All rights reserved.
//
#import "SimpleDecorationView.h"
#import "SimpleCollectionViewFlowLayout.h"

static NSString *SIMPLEDECORATIONKIND = @"Simple Decoration Kind";

@implementation SimpleCollectionViewFlowLayout

- (instancetype)init {
    if (!(self = [super init])) {
        return nil;
    }
    self.minimumInteritemSpacing = 20;
    self.minimumLineSpacing = 40;
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.itemSize = CGSizeMake(50, 50);
    
    [self registerClass:[SimpleDecorationView class] forDecorationViewOfKind:SIMPLEDECORATIONKIND];
    return self;
}

#pragma mark - Layout Attributes
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *newArray = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attrs in array) {
        UICollectionViewLayoutAttributes *newAttrs = [attrs copy];
        // 设置每一个 item
        if (attrs.representedElementKind == nil) {
            if (attrs.indexPath.item == 5 && attrs.indexPath.section == 1) {
                newAttrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:5 inSection:1]];
            }
        }
        
        // 设置每一个 SupplementaryView
        if (attrs.representedElementCategory == UICollectionElementCategorySupplementaryView) {
            if (attrs.indexPath.section == 1) {
                newAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
            }
            newAttrs.frame = CGRectMake(100, 100, 100, 100);
        }
        
        [newArray addObject:newAttrs];
    }
    // 设置 DecorationView
    if ([self.collectionView numberOfSections] >1) {
        UICollectionViewLayoutAttributes *newAttrs = [self layoutAttributesForDecorationViewOfKind:SIMPLEDECORATIONKIND atIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
        [newArray addObject:newAttrs];
    }
    
    return newArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *itemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    itemAttributes.transform = CGAffineTransformMakeRotation(-45);
    return itemAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *itemAttributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    itemAttributes.transform = CGAffineTransformMakeRotation(45);
    return itemAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *decorationAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
    UICollectionViewLayoutAttributes *newDecorationAttributes = [decorationAttributes copy];
    if ([elementKind isEqualToString:SIMPLEDECORATIONKIND]) {
        NSIndexPath *indexPathFirst = [NSIndexPath indexPathForItem:0 inSection:1];
        NSIndexPath *indexPathLast = [NSIndexPath indexPathForItem:[self.collectionView numberOfItemsInSection:1] inSection:1];
        UICollectionViewLayoutAttributes *attrsFirst = [self layoutAttributesForItemAtIndexPath:indexPathFirst];
        UICollectionViewLayoutAttributes *attrsLast = [self layoutAttributesForItemAtIndexPath:indexPathLast];
        newDecorationAttributes.frame = CGRectMake(attrsFirst.frame.origin.x, attrsFirst.frame.origin.y, self.collectionView.frame.size.width, attrsLast.frame.origin.y-attrsFirst.frame.origin.y);
        // 想要作为背景图像，就一定要将其 zIndex 设置为 -1
        newDecorationAttributes.zIndex = -1;
    }
    return newDecorationAttributes;
}



@end
