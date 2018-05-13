//
//  ZZJijinCellCollectionViewCell.h
//  AnXinCaiFu
//
//  Created by zzz on 16/6/3.
//  Copyright © 2016年 Blue Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZJijinModel.h"
@interface ZZJijinCellCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UIView *view1;

@property (nonatomic, strong) ZZJijinModel * model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1Top;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label1Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label1Height;


@end
