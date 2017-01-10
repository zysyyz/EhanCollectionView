//
//  SCCollectionViewLayout.m
//  UICollectionViewTest
//
//  Created by pengehan on 17/1/5.
//  Copyright © 2017年 pengehan. All rights reserved.
//

#import "SCCollectionViewLayout.h"

#define CellMarginWidth 40
#define CellTopBottomSpaceHeight 40

@implementation SCCollectionViewLayout

-(CGSize)collectionViewContentSize{
    //高度
    CGFloat contentHeight = self.collectionView.bounds.size.height;

    //计算出宽度
    CGFloat cellWidth = self.collectionView.bounds.size.width - 2 * CellMarginWidth;
    NSInteger numsOfItem = [self.collectionView numberOfItemsInSection:0];
    CGFloat contentWidth = 1.5 * CellMarginWidth + numsOfItem * (cellWidth + CellMarginWidth/2.0);
    
    return CGSizeMake(contentWidth, contentHeight);
}


//传入当前可视区域，算出各个类型的IndexPatch，然后根据indexPatch算出Attributes
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    // Cells
    NSArray *visibleIndexPaths = [self indexPathsOfItemsInRect:rect];
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    return layoutAttributes;
}


#pragma mark - Helpers

- (NSArray *)indexPathsOfItemsInRect:(CGRect)rect
{
    CGFloat minVisibleXPosition = CGRectGetMinX(rect);
    CGFloat maxVisibleXPosttion = CGRectGetMaxX(rect);
    CGFloat cellWidth = self.collectionView.bounds.size.width - 2 * CellMarginWidth;
    
    NSInteger minIndex = (NSInteger)(( MAX(minVisibleXPosition - CellMarginWidth,0) ) / (cellWidth + CellMarginWidth/2.0));
    NSInteger maxIndex = (NSInteger)((maxVisibleXPosttion - CellMarginWidth) / (cellWidth + CellMarginWidth/2.0));
    
    NSInteger numsOfItem = [self.collectionView numberOfItemsInSection:0];
    
    maxIndex = MIN(maxIndex, numsOfItem - 1);
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSInteger startIndex = minIndex; startIndex <= maxIndex; startIndex ++) {
        [array addObject:[NSIndexPath indexPathForRow:startIndex inSection:0]];
    }
    
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = [self frameForRow:indexPath.row];
    return attributes;
}

-(CGRect)frameForRow:(NSInteger)row{
    
    CGFloat cellWidth = self.collectionView.bounds.size.width - 2 * CellMarginWidth;
    CGFloat cellHeight = self.collectionView.bounds.size.height - 2 * CellTopBottomSpaceHeight;
    
    CGFloat x = CellMarginWidth + row * (cellWidth + CellMarginWidth/2.0);
    CGFloat y = CellTopBottomSpaceHeight;
    
    return  CGRectMake(x, y, cellWidth, cellHeight);
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}






@end
