//
//  SCCollectionView.h
//  UICollectionViewTest
//
//  Created by pengehan on 17/1/5.
//  Copyright © 2017年 pengehan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCollectionLRView.h"
@class SCCollectionView;

@protocol SCCollectionRefreshAndLoad <NSObject>

-(BOOL)hasNewToRefresh;
-(void)refreshForSCollectionView:(SCCollectionView *)view;

-(BOOL)hasMoreToload;
-(void)loadMoreForSCollectionView:(SCCollectionView *)view;

@end



@interface SCCollectionView : UICollectionView<SCCollectionLRViewDelegate>
@property(nonatomic,assign)BOOL needRefresh;
@property(nonatomic,assign)BOOL needLoadMore;

@property(nonatomic,strong)SCCollectionLRView *refreshView;
@property(nonatomic,strong)SCCollectionLRView *loadMoreView;

@property(nonatomic,assign)UIEdgeInsets originalContentInset;

@property(nonatomic,assign)id<SCCollectionRefreshAndLoad> refreshAndLoadDelegate;


-(void)endRefreshingOrLoading;

@end
