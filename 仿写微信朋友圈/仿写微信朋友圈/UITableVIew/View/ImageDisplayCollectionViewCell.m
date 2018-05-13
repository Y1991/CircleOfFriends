//
//  ImageDisplayCollectionViewCell.m
//  仿写微信朋友圈
//
//  Created by Guangquan Yu on 2017/11/16.
//  Copyright © 2017年 ZHM.YU. All rights reserved.
//

#import "ImageDisplayCollectionViewCell.h"
@interface ImageDisplayCollectionViewCell ()

@property (nonatomic,strong) UILabel * label1;
@end
@implementation ImageDisplayCollectionViewCell
-(void)prepareForReuse{
    [super prepareForReuse];
    _imageView1.image = nil;
    _label1.text = nil;

}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _label1 = [UIView makeLabel:CGRectZero backColor:[UIColor whiteColor] numberOfLines:0];
        [self.contentView addSubview:_label1];
        
        _imageView1 = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        _imageView1.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:_imageView1];
        
        [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self);
        }];
        [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self);
        }];
    }
    return self;
}

- (void)setModel:(ZZJijinModel *)model{
    _model = model;
    UIImage * image = [UIImage imageNamed:model.stateImageName];
    if (image) {
        self.imageView1.image = image;
    } 
    
    self.label1.text = model.title ;
}
@end
