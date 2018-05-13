//
//  YGQ_FriendCircleImageDisplay.h
//  仿写微信朋友圈
//
//  Created by Guangquan Yu on 2017/11/14.
//  Copyright © 2017年 ZHM.YU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZJijinModel.h"
@interface YGQ_FriendCircleImageDisplay : UIView
@property(nonatomic,strong)NSDictionary * countDic;
@property (nonatomic,strong)UICollectionView *collectionView;

+ (CGSize)getCollectionSizeWithCount:(NSInteger)count;
@end
