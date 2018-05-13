//
//  ImageDisplayCollectionViewCell.h
//  仿写微信朋友圈
//
//  Created by Guangquan Yu on 2017/11/16.
//  Copyright © 2017年 ZHM.YU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZJijinModel.h"
@interface ImageDisplayCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView * imageView1;

@property (nonatomic, strong) ZZJijinModel * model;
@end
