//
//  ZZJijinCellCollectionViewCell.m
//  AnXinCaiFu
//
//  Created by zzz on 16/6/3.
//  Copyright © 2016年 Blue Mobi. All rights reserved.
//

#import "ZZJijinCellCollectionViewCell.h"

#define DEF_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define FontScale (DEF_SCREEN_WIDTH/320.0)
@implementation ZZJijinCellCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

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
