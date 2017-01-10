//
//  ViewController.m
//  UICollectionViewTest
//
//  Created by pengehan on 17/1/5.
//  Copyright © 2017年 pengehan. All rights reserved.
//

#import "ViewController.h"
#import "SCCollectionView.h"
#import "SCCollectionViewLayout.h"
#import "SCCollectionViewModel.h"

@interface ViewController ()
@property(nonatomic,strong)SCCollectionView *collectionView;
@property(nonatomic,strong)SCCollectionViewLayout *colletionViewLayout;
@property(nonatomic,strong)SCCollectionViewModel *collectionViewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUpSubViews];
}

-(void)setUpSubViews{
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    
    [self.collectionViewModel request:^{
        [self.view addSubview:self.collectionView];
    }];
}

#pragma mark ---- 懒加载
-(SCCollectionViewModel *)collectionViewModel{
    if (!_collectionViewModel) {
        _collectionViewModel = [[SCCollectionViewModel alloc]initWithCollectionView:self.collectionView];
    }
    return _collectionViewModel;
}


-(SCCollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[SCCollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.colletionViewLayout];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
    }
    return _collectionView;
}


-(SCCollectionViewLayout *)colletionViewLayout{
    if (!_colletionViewLayout) {
        _colletionViewLayout = [SCCollectionViewLayout new];
    }
    return _colletionViewLayout;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
