//
//  SCCollectionLRView.m
//  UICollectionViewTest
//
//  Created by pengehan on 17/1/9.
//  Copyright © 2017年 pengehan. All rights reserved.
//

#import "SCCollectionLRView.h"

#define defaultPreRefreshStringForLeftMode @"左拉刷新";
#define defaultPreRefreshStringForRightMode @"右拉加载更多";
#define defaultWillRefreshString @"释放刷新";
#define defaultRefreshingString @"正在刷新";

@interface SCCollectionLRView ()

@property(nonatomic,strong)UILabel *titsLabel;

@end

@implementation SCCollectionLRView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpSubViews];
        _isLeftModel = NO;
        [self showPreRefreshStatus:CGPointZero];
        
    }
    return self;
}

-(void)setUpSubViews{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.titsLabel];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.titsLabel attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    centerX.priority = UILayoutPriorityRequired;
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.titsLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    centerY.priority = UILayoutPriorityRequired;
    
    [self addConstraints:@[centerX,centerY]];
}


-(void)setUpText:(NSString *)text{
    NSMutableString *string = [[NSMutableString alloc] initWithString:[text substringWithRange:NSMakeRange(0, 1)]];
    for (int i = 1; i<text.length; i++) {
        [string appendString:[NSString stringWithFormat:@"\n%@",[text substringWithRange:NSMakeRange(i, 1)]]];
    }
    self.titsLabel.text = string;
}

-(void)updateTitsLabelText{
    
    NSString *titsString;
    
    switch (self.refreshStatus) {
        case PreRefreshStatus:
        {
            if (self.titsDelegate && [self.titsDelegate respondsToSelector:@selector(titsStringForPreRefreshStatus:)]) {
                titsString = [self.titsDelegate titsStringForPreRefreshStatus:self];
            }
            if (!titsString) {
                if (self.isLeftModel) {
                    titsString = defaultPreRefreshStringForLeftMode;
                }else{
                    titsString = defaultPreRefreshStringForRightMode;
                }
            }
            [self setUpText:titsString];
            break;
        }
            
        case WillRefreshStatus:
        {
            if (self.titsDelegate && [self.titsDelegate respondsToSelector:@selector(titsStringForWillRefreshStatus:)]) {
                titsString = [self.titsDelegate titsStringForWillRefreshStatus:self];
            }
            if (!titsString) {
                titsString = defaultWillRefreshString;
            }
            [self setUpText:titsString];
            break;
        }
            
        case RefreshingStatus:
        {
            if (self.titsDelegate && [self.titsDelegate respondsToSelector:@selector(titsStringForRefreshingStatus:)]) {
                titsString = [self.titsDelegate titsStringForRefreshingStatus:self];
            }
            if (!titsString) {
                titsString = defaultRefreshingString;
            }
            [self setUpText:titsString];
            break;
        }
            
        default:
            break;
    }

}


-(void)setIsLeftModel:(BOOL)isLeftModel{
    _isLeftModel = isLeftModel;
    [self showPreRefreshStatus:CGPointZero];
}


-(void)showPreRefreshStatus:(CGPoint)contentOffset{
    self.refreshStatus = PreRefreshStatus;
    [self updateTitsLabelText];
//    [self setNeedsDisplay];
    
}

-(void)showWillRefreshStatus:(CGPoint)contentOffset{
    self.refreshStatus =  WillRefreshStatus;
    [self updateTitsLabelText];
//    [self setNeedsDisplay];
    
}

-(void)showRefreshingStatus:(CGPoint)contentOffset{
    self.refreshStatus = RefreshingStatus;
    [self updateTitsLabelText];
//    [self setNeedsDisplay];
    
}


-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
//    [self setNeedsDisplay];
}


-(UILabel *)titsLabel{
    if (!_titsLabel) {
        _titsLabel = [UILabel new];
        _titsLabel.numberOfLines = 0;
        _titsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titsLabel.font = [UIFont systemFontOfSize:14];
        _titsLabel.textColor = [UIColor blackColor];
        _titsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titsLabel;
    
}

- (void)drawRect:(CGRect)rect {
    
    NSLog(@"drawRect里面的参数rect: %@",NSStringFromCGRect(rect));
    
    if (self.isLeftModel) {  //左拉
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(rect.size.width/2.0, 0)];
        
        [path addQuadCurveToPoint:CGPointMake(rect.size.width/2.0, rect.size.height) controlPoint:CGPointMake(rect.size.width, rect.size.height/2.0)];
        
        [path addLineToPoint:CGPointMake(0, rect.size.height)];
        
        [[UIColor lightGrayColor]setFill];
        [[UIColor lightGrayColor]setStroke];
        [path closePath];
        [path fill];
        [path stroke];
    }else{  //右拉
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(rect.size.width, 0)];
        [path addLineToPoint:CGPointMake(rect.size.width/2.0, 0)];
        [path addQuadCurveToPoint:CGPointMake(rect.size.width/2.0, rect.size.height) controlPoint:CGPointMake(0, rect.size.height/2.0)];
        [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
        [[UIColor lightGrayColor]setFill];
        [[UIColor lightGrayColor]setStroke];
        [path closePath];
        [path fill];
        [path stroke];
    }
}


@end
