//
//  SCCollectionView.m
//  UICollectionViewTest
//
//  Created by pengehan on 17/1/5.
//  Copyright © 2017年 pengehan. All rights reserved.
//

#import "SCCollectionView.h"

#define RefreshViewWidth 40

@interface SCCollectionView ()
@property(nonatomic,assign)BOOL isRefreshing;
@property(nonatomic,assign)BOOL isLoading;

@end

@implementation SCCollectionView

-(void)initialization
{
    _needLoadMore=NO;
    _needRefresh=NO;
    _isLoading=NO;
    _isRefreshing=NO;
    [self.panGestureRecognizer addTarget:self action:@selector(pan:)];
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initialization];
    }
    return self;
}


#pragma mark - needLoadMoreStuff


-(void)setNeedLoadMore:(BOOL)needLoadMore{
    _needLoadMore = needLoadMore;
    if (_needLoadMore) {
        if (!_loadMoreView) {
            _loadMoreView = [[SCCollectionLRView alloc]initWithFrame:CGRectMake(0, 0, RefreshViewWidth, self.bounds.size.height)];
            _loadMoreView.isLeftModel = NO;
            _loadMoreView.titsDelegate = self;
            [self addSubview:_loadMoreView];
        }
    }
}


-(void)setNeedRefresh:(BOOL)needRefresh{
    _needRefresh = needRefresh;
    if (_needRefresh) {
        if (!_refreshView) {
            _refreshView = [[SCCollectionLRView alloc]initWithFrame:CGRectMake(0, 0, RefreshViewWidth, self.bounds.size.height)];
            _refreshView.isLeftModel = YES;
            _refreshView.titsDelegate = self;
            [self addSubview:_refreshView];
        }
    }
}

-(void)reloadData
{
    [super reloadData];
    [self resume];
}

-(void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    if(!_isRefreshing)
        [self rePositionRefreshView];
    if(!_isLoading)
        [self rePositionLoadMoreView];
}

-(void)resume
{
    CGPoint contentOffset = self.contentOffset;

    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentInset = _originalContentInset;
        if (_isLoading)
            self.contentOffset = contentOffset;
    } completion:^(BOOL finished) {
        [self resumeFromLoading];
        [self resumeFromRefreshing];
    }];
}

-(void)resumeFromLoading
{
    _isLoading=NO;
    [_loadMoreView showPreRefreshStatus:CGPointZero];
    if(_loadMoreView)
    {
        if(![_refreshAndLoadDelegate respondsToSelector:@selector(hasMoreToload)]
           ||[_refreshAndLoadDelegate hasMoreToload])
        {
            [self rePositionLoadMoreView];
            _loadMoreView.hidden=NO;
        }
        else
            _loadMoreView.hidden=YES;
    }
}

-(void)resumeFromRefreshing
{
    _isRefreshing=NO;
    [_refreshView showPreRefreshStatus:CGPointZero];
    if(_refreshView)
    {
        if(![_refreshAndLoadDelegate respondsToSelector:@selector(hasNewToRefresh)]
           ||[_refreshAndLoadDelegate hasNewToRefresh])
        {
            [self rePositionRefreshView];
            _refreshView.hidden=NO;
        }
        else
            _refreshView.hidden=YES;
    }
}

-(void)endRefreshingOrLoading
{
    _loadMoreView.hidden = YES;
    _refreshView.hidden = YES;
    if(_isLoading)
    {
        NSUInteger numOfSections = 1; //默认section数量为1
        if([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
            numOfSections = [self.dataSource numberOfSectionsInCollectionView:self];
        
        NSUInteger oldNumOfSections = [self numberOfSections];
        NSMutableArray *indexPathsArray = [NSMutableArray array];
        
        for(NSUInteger i = 0; i < numOfSections;i++)
        {
            NSUInteger oldRowNum;
            if (i >= oldNumOfSections) {
                oldRowNum = 0;
            }else{
                oldRowNum = [self numberOfItemsInSection:i];
            }
            NSUInteger newRowNum = [self.dataSource collectionView:self numberOfItemsInSection:i];
            NSMutableArray *indexPaths = [NSMutableArray array];
            for(NSUInteger row =oldRowNum; row < newRowNum; row++)
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:i];
                [indexPaths addObject:indexPath];
            }
            [indexPathsArray addObject:[indexPaths copy]];
        }
        
        
        for(NSArray *indexPaths in indexPathsArray)
        {
            for (NSIndexPath *index in indexPaths) {
                if (index.section >= oldNumOfSections) {
                    NSIndexSet *set = [NSIndexSet indexSetWithIndex:index.section];
                    [self insertSections:set];
                    if([indexPaths count])
                        [self insertItemsAtIndexPaths:indexPaths];
                    break;
                }else{
                    if([indexPaths count]){
                        
                        [self performBatchUpdates:^{
                            [self insertItemsAtIndexPaths:indexPaths];
                        } completion:nil];
                        
                    }
                    
                    
                    break;
                }
            }
        }
    }else{
        [self reloadData];
    }
    
    [self resume];
}

-(void)rePositionLoadMoreView
{
    float baseOffset=self.contentSize.width-self.frame.size.width+self.contentInset.right;
    baseOffset=MAX(baseOffset, 0);
    float bounceOffset=self.contentOffset.x-baseOffset;
    
    if (bounceOffset > 0) {
        _loadMoreView.frame=CGRectMake(self.contentSize.width>self.frame.size.width?self.contentSize.width:self.frame.size.width, 0, RefreshViewWidth + bounceOffset, _loadMoreView.frame.size.height);
    }else{
        _loadMoreView.frame=CGRectMake(self.contentSize.width>self.frame.size.width?self.contentSize.width:self.frame.size.width, 0, RefreshViewWidth , _loadMoreView.frame.size.height);
    }
    
}

-(void)rePositionRefreshView
{
    if (self.contentOffset.x < 0) {
        _refreshView.frame=CGRectMake(-RefreshViewWidth+self.contentOffset.x, 0,RefreshViewWidth - self.contentOffset.x, _refreshView.frame.size.height);
    }else{
        _refreshView.frame=CGRectMake(-RefreshViewWidth, 0, RefreshViewWidth, _refreshView.frame.size.height);
    }
     NSLog(@"%@",NSStringFromCGRect(_refreshView.frame));
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self rePositionRefreshView];
    [self rePositionLoadMoreView];
}

-(void)pan:(UIPanGestureRecognizer*)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateChanged)
        [self changeStateByOffset];
    else if(recognizer.state == UIGestureRecognizerStateEnded)
        [self startLoading];
}

#define MAXBOUNCEOFFSET 10
- (void)changeStateByOffset
{
    float bounceOffset;
    if(_needRefresh&&!_isRefreshing)
    {
        bounceOffset=-self.contentOffset.x;
        
        if (self.contentOffset.x < 0) {
            _refreshView.frame=CGRectMake(-RefreshViewWidth+self.contentOffset.x, 0,RefreshViewWidth - self.contentOffset.x, _refreshView.frame.size.height);
        }else{
            _refreshView.frame=CGRectMake(-RefreshViewWidth, 0, RefreshViewWidth, _refreshView.frame.size.height);
        }
        NSLog(@"%@",NSStringFromCGRect(_refreshView.frame));
        
        CGPoint offsetPoint = CGPointMake(self.contentOffset.x, 0);
        
        if(bounceOffset > RefreshViewWidth + MAXBOUNCEOFFSET)
        {
            [_refreshView showWillRefreshStatus:offsetPoint];
        }
        else if(bounceOffset <= RefreshViewWidth + MAXBOUNCEOFFSET)
        {
            [_refreshView showPreRefreshStatus:offsetPoint];
        }
        
        
    }
    if(_needLoadMore&&!_isLoading)
    {
        float baseOffset=self.contentSize.width-self.frame.size.width+self.contentInset.right;
        baseOffset=MAX(baseOffset, 0);
        bounceOffset=self.contentOffset.x-baseOffset;
        
        if (bounceOffset > 0) {
            _loadMoreView.frame=CGRectMake(self.contentSize.width>self.frame.size.width?self.contentSize.width:self.frame.size.width, 0, RefreshViewWidth + bounceOffset, _loadMoreView.frame.size.height);
        }else{
            _loadMoreView.frame=CGRectMake(self.contentSize.width>self.frame.size.width?self.contentSize.width:self.frame.size.width, 0, RefreshViewWidth , _loadMoreView.frame.size.height);
        }
        
        
        CGPoint offsetPoint = CGPointMake(bounceOffset, 0);
        
        if(bounceOffset > RefreshViewWidth + MAXBOUNCEOFFSET)
        {
            [_loadMoreView showWillRefreshStatus:offsetPoint];
        }
        else if(bounceOffset <= RefreshViewWidth + MAXBOUNCEOFFSET){
            [_loadMoreView showPreRefreshStatus:offsetPoint];
        }
        
    }
}



- (void)startLoading
{
    float bounceOffset;
    if(_needRefresh&&!_isRefreshing)
    {
        bounceOffset=-self.contentOffset.x;
        if(bounceOffset >= RefreshViewWidth + MAXBOUNCEOFFSET)
        {
            [self performRefresh];
        }
    }
    if(_needLoadMore&&!_isLoading)
    {
        float baseOffset=self.contentSize.width-self.frame.size.width+self.contentInset.right;
        baseOffset=MAX(baseOffset, 0);
        bounceOffset=self.contentOffset.x-baseOffset;
        if(bounceOffset >= RefreshViewWidth + MAXBOUNCEOFFSET)
        {
            [self performLoadMore];
        }
    }
}

-(void)tryToPerformRefresh
{
    if(!self.needRefresh)
        return;
    [self performRefresh];
}

-(void)performRefresh
{
    if(![_refreshAndLoadDelegate respondsToSelector:@selector(hasNewToRefresh)]
       ||[_refreshAndLoadDelegate hasNewToRefresh])
    {
        [_refreshView showRefreshingStatus:CGPointZero];
        _isRefreshing=YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.contentInset=UIEdgeInsetsMake(0, RefreshViewWidth, 0, 0);
        } completion:^(BOOL finished) {
            if([_refreshAndLoadDelegate respondsToSelector:@selector(refreshForSCollectionView:)])
                [_refreshAndLoadDelegate refreshForSCollectionView:self];
        }];
    }
}

- (void)tryToPerformLoadMore
{
    if (!self.needLoadMore)
        return;
    [self performLoadMore];
}

- (void)performLoadMore
{
    if(![_refreshAndLoadDelegate respondsToSelector:@selector(hasMoreToload)]
       ||[_refreshAndLoadDelegate hasMoreToload])
    {
        [_loadMoreView showRefreshingStatus:CGPointZero];
        _isLoading=YES;
        
        
        [UIView animateWithDuration:0.25 animations:^{
            float additionalHeight=MAX(self.frame.size.width-self.contentSize.width,0);
            self.contentInset= UIEdgeInsetsMake(0, 0, 0, RefreshViewWidth+additionalHeight+self.contentInset.right);
        } completion:^(BOOL finished) {
            if([_refreshAndLoadDelegate respondsToSelector:@selector(loadMoreForSCollectionView:)])
                [_refreshAndLoadDelegate loadMoreForSCollectionView:self];
        }];
    }
}

-(void)setContentInset:(UIEdgeInsets)contentInset{
    [super setContentInset:contentInset];
}


@end
