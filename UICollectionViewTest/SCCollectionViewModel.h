//
//  SCCollectionViewDelegate.h
//  UICollectionViewTest
//
//  Created by pengehan on 17/1/5.
//  Copyright © 2017年 pengehan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SCCollectionView.h"


@interface SCCollectionViewModel : NSObject<UICollectionViewDataSource,UICollectionViewDelegate,SCCollectionRefreshAndLoad>
-(instancetype)initWithCollectionView:(SCCollectionView *)collectionView;
-(void)request:(void (^)(void))completeHandler;
-(void)add:(void(^)(void))completeHandler;
-(void)del:(void(^)(void))completeHandler;
@end
