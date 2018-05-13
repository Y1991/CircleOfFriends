//
//  SDTimeLineCellOperationMenu.m
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/4/2.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import "SDTimeLineCellOperationMenu.h"

@implementation SDTimeLineCellOperationMenu
{
    UIButton *_likeButton;
    UIButton *_commentButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor blackColor];
    
    _likeButton = [self creatButtonWithTitle:@"赞" image:[UIImage imageNamed:@"AlbumLike"] selImage:[UIImage imageNamed:@""] target:self selector:@selector(likeButtonClicked)];
    _commentButton = [self creatButtonWithTitle:@"评论" image:[UIImage imageNamed:@"AlbumComment"] selImage:[UIImage imageNamed:@""] target:self selector:@selector(commentButtonClicked)];
    
    UIView *centerLine = [UIView new];
    centerLine.backgroundColor = [UIColor grayColor];
    
    [self addSubview:_likeButton];
    [self addSubview:_commentButton];
    [self addSubview:centerLine];
//    [self sd_addSubviews:@[_likeButton, _commentButton, centerLine]];
    
    CGFloat margin = 5;
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(margin);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(80);
    }];
//    _likeButton.sd_layout
//    .leftSpaceToView(self, margin)
//    .topEqualToView(self)
//    .bottomEqualToView(self)
//    .widthIs(80);
    
    [centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_likeButton.mas_right).offset(margin);
        make.top.equalTo(self).offset(margin);
        make.bottom.equalTo(self).offset(margin);
        make.width.mas_equalTo(1);
    }];
//    centerLine.sd_layout
//    .leftSpaceToView(_likeButton, margin)
//    .topSpaceToView(self, margin)
//    .bottomSpaceToView(self, margin)
//    .widthIs(1);
    
    [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerLine.mas_right).offset(margin);
        make.top.equalTo(_likeButton);
        make.bottom.equalTo(_likeButton);
        make.width.equalTo(_likeButton);
    }];
//    _commentButton.sd_layout
//    .leftSpaceToView(centerLine, margin)
//    .topEqualToView(_likeButton)
//    .bottomEqualToView(_likeButton)
//    .widthRatioToView(_likeButton, 1);
    
}

- (UIButton *)creatButtonWithTitle:(NSString *)title image:(UIImage *)image selImage:(UIImage *)selImage target:(id)target selector:(SEL)sel
{
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    return btn;
}

- (void)likeButtonClicked
{
    if (self.likeButtonClickedOperation) {
        self.likeButtonClickedOperation();
    }
    self.show = NO;
}

- (void)commentButtonClicked
{
    if (self.commentButtonClickedOperation) {
        self.commentButtonClickedOperation();
    }
    self.show = NO;
}

- (void)setShow:(BOOL)show
{
    _show = show;
    
    [UIView animateWithDuration:0.2 animations:^{
        if (!show) {
            //[self clearAutoWidthSettings];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(_likeButton).offset(margin);
//                make.top.equalTo(self).offset(margin);
//                make.bottom.equalTo(self).offset(margin);
                make.width.mas_equalTo(0);
            }];
        } else {
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                //                make.left.equalTo(_likeButton).offset(margin);
                //                make.top.equalTo(self).offset(margin);
                //                make.bottom.equalTo(self).offset(margin);
                make.width.mas_equalTo(181);
            }];
//            self.fixedWidth = nil;
//            [self setupAutoWidthWithRightView:_commentButton rightMargin:5];
        }

    }];
}

@end
