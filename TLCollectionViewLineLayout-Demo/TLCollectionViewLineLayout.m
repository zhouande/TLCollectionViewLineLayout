//
//  TLCollectionViewLineLayout.m
//  TLCollectionViewLineLayout-Demo
//
//  Created by andezhou on 15/7/16.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import "TLCollectionViewLineLayout.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define ITEM_WIDTH kScreenWidth*0.6
#define ITEM_HEIGHT kScreenHeight*0.5

#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.3

@implementation TLCollectionViewLineLayout

-(id)init {
    self = [super init];
    if (self) {
        CGFloat margin = (kScreenWidth - ITEM_WIDTH)/2.0;
        self.itemSize = CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(0, ABS(margin), 0, ABS(margin));
        self.minimumLineSpacing = 50;
    }
    return self;
}

// 刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds {
    return YES;
}

// 当前item放大
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    CGRect visibleRect = CGRectZero;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    // 遍历array中所有的UICollectionViewLayoutAttributes
    for (UICollectionViewLayoutAttributes *attributes in array) {
        
        if (CGRectIntersectsRect(attributes.frame, rect)) {

            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            
            if (ABS(distance) < ACTIVE_DISTANCE) {
                CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
                
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
            }
        }
    }
    return array;
}

// 自动对齐到网格
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity {
    // proposedContentOffset是没有对齐到网格时本来应该停下的位置
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    
    CGFloat offsetAdjustment = MAXFLOAT;
    //理论上应cell停下来的中心点
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
