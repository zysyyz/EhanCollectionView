//
//  SCCollectionViewDelegate.m
//  UICollectionViewTest
//
//  Created by pengehan on 17/1/5.
//  Copyright © 2017年 pengehan. All rights reserved.
//

#import "SCCollectionViewModel.h"
#import "SCCollectionViewCell.h"
#import "SCCollectionView.h"

#define CellId @"cellId"

#define CellSpaceWidth 40

@interface SCCollectionViewModel ()
@property(weak,nonatomic)SCCollectionView *collectionView;
@property(assign,nonatomic)NSInteger arrCount;
@end

@implementation SCCollectionViewModel

-(void)add:(void(^)(void))completeHandler{
    self.arrCount ++;
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.arrCount - 1 inSection:0]]];
}


-(void)del:(void(^)(void))completeHandler{
    self.arrCount --;
    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.arrCount inSection:0]]];
}


-(void)request:(void (^)(void))completeHandler{
    if (completeHandler) {
        completeHandler();
    }
}

-(instancetype)initWithCollectionView:(SCCollectionView *)collectionView{
    self = [super init];
    if (self) {
        self.collectionView = collectionView;
        [self configCollectionView];
        [self configDataSource];
        
        
    }
    return self;
}

-(void)configDataSource{
    self.arrCount = 10;
}

#pragma mark ---- UIScrollViewDelegate
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{

    if (self.collectionView.needRefresh && self.collectionView.refreshView.refreshStatus == WillRefreshStatus) {
        return;
    }
    
    if ((self.collectionView.needLoadMore && self.collectionView.loadMoreView.refreshStatus == WillRefreshStatus)) {
        return;
    }
    
    CGFloat cellWidth = self.collectionView.bounds.size.width - 2 * CellSpaceWidth;
    CGFloat startXPosition = targetContentOffset->x;
    CGFloat middleXPosition = startXPosition + self.collectionView.bounds.size.width / 2.0;
    
    CGFloat realXPosition = MAX(middleXPosition - CellSpaceWidth, 0);
    NSInteger index = realXPosition / (cellWidth + CellSpaceWidth/2.0);
    targetContentOffset->x = index * (cellWidth + CellSpaceWidth/2.0);
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat startXPosition = scrollView.contentOffset.x;
    CGFloat middleXPosition = startXPosition + self.collectionView.bounds.size.width / 2.0;
    
    CGFloat cellWidth = self.collectionView.bounds.size.width - 2 * CellSpaceWidth;
    
    NSInteger minIndex = (NSInteger)(( MAX(startXPosition - CellSpaceWidth,0) ) / (cellWidth + CellSpaceWidth/2.0));
    NSInteger maxIndex = (NSInteger)((startXPosition - CellSpaceWidth + self.collectionView.bounds.size.width) / (cellWidth + CellSpaceWidth/2.0));
    maxIndex = MIN(maxIndex, [self.collectionView numberOfItemsInSection:0] - 1);
    
    for (NSInteger index = minIndex; index <= maxIndex; index ++) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        float rate = cosf( (fabs(middleXPosition - CGRectGetMidX(cell.frame)) / self.collectionView.contentSize.width ) * M_PI );
        cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, rate);
    }
}


-(void)configCollectionView{
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.refreshAndLoadDelegate = self;
    self.collectionView.needLoadMore = YES;
    self.collectionView.needRefresh = YES;
    
    [self.collectionView registerClass:[SCCollectionViewCell class] forCellWithReuseIdentifier:CellId];
}


#pragma mark ---- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrCount;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
    NSString *titleString = [NSString stringWithFormat:@"第%ld个",indexPath.row];
    [cell configWithTitle:titleString];
    float rate = cosf( (fabs(self.collectionView.bounds.size.width/2.0 - CGRectGetMidX(cell.frame)) / self.collectionView.contentSize.width ) * M_PI );
    cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, rate);
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger rowIndex = indexPath.row;
    
    CGFloat cellWidth = self.collectionView.bounds.size.width - 2 * CellSpaceWidth;
    CGPoint offsetPoint = CGPointMake(rowIndex * (cellWidth + CellSpaceWidth/2.0),0);
    [self.collectionView setContentOffset:offsetPoint animated:YES];
    
}


#pragma mark ---- RefreshAndLoadMore
-(BOOL)hasNewToRefresh{
    return YES;
}

-(void)refreshForSCollectionView:(SCCollectionView *)view{

    __weak SCCollectionViewModel *weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        weakSelf.arrCount = 10;
         [weakSelf.collectionView endRefreshingOrLoading];
    });
   
}

-(BOOL)hasMoreToload{
    return YES;
}

-(void)loadMoreForSCollectionView:(SCCollectionView *)view{
    
    __weak SCCollectionViewModel *weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        weakSelf.arrCount += 5;
        [weakSelf.collectionView endRefreshingOrLoading];
    });
}


@end
