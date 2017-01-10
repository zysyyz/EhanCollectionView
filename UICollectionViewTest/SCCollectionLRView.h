//
//  SCCollectionLRView.h
//  UICollectionViewTest
//
//  Created by pengehan on 17/1/9.
//  Copyright © 2017年 pengehan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCCollectionLRView;

typedef NS_ENUM(NSInteger,RefreshStatus){
    PreRefreshStatus = 1,
    WillRefreshStatus,
    RefreshingStatus,
};

@protocol SCCollectionLRViewDelegate <NSObject>

-(NSString *)titsStringForPreRefreshStatus:(SCCollectionLRView *)view;
-(NSString *)titsStringForWillRefreshStatus:(SCCollectionLRView *)view;
-(NSString *)titsStringForRefreshingStatus:(SCCollectionLRView *)view;

@end

@interface SCCollectionLRView : UIView
@property(nonatomic,assign)BOOL isLeftModel;
@property(nonatomic,assign)RefreshStatus refreshStatus;

@property(nonatomic,assign)id<SCCollectionLRViewDelegate> titsDelegate;

-(void)showPreRefreshStatus:(CGPoint)contentOffset;
-(void)showWillRefreshStatus:(CGPoint)contentOffset;
-(void)showRefreshingStatus:(CGPoint)contentOffset;


@end
