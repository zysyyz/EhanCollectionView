//
//  SCCollectionViewCell.m
//  UICollectionViewTest
//
//  Created by pengehan on 17/1/5.
//  Copyright © 2017年 pengehan. All rights reserved.
//

#import "SCCollectionViewCell.h"

@interface SCCollectionViewCell ()
@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)UIView *containerView;
@property(strong,nonatomic)UIImageView *imageView;
@end

@implementation SCCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubViews];
    }
    return self;
}

-(void)configWithTitle:(NSString *)titleString{
    self.titleLabel.text = titleString;
}


-(void)setUpSubViews{
    
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    self.contentView.layer.cornerRadius = 4;
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentView.layer.shadowRadius = 4;
    self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
    self.contentView.layer.shadowOpacity = 0.5;
    
    [self.contentView addSubview:self.containerView];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_containerView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_containerView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_containerView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_containerView)]];
    
    [self.containerView addSubview:self.imageView];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:10]];
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}


-(UIView *)containerView{
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 4;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}


-(UIImageView *)imageView{
    if (!_imageView) {
        
        UIImage *image = [UIImage imageNamed:@"image"];
        _imageView = [[UIImageView alloc]initWithImage:image];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_imageView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:image.size.width]];
        [_imageView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:image.size.height]];
        
        _imageView.layer.cornerRadius = 4;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

@end
