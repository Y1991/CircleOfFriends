//
//  YGQ_FriendCircleImageDisplayNew.h
//  仿写微信朋友圈
//
//  Created by Guangquan Yu on 2017/11/16.
//  Copyright © 2017年 ZHM.YU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZJijinModel.h"

@interface YGQ_FriendCircleImageDisplayNew : UIView
@property(nonatomic,strong)NSDictionary * countDic;

+ (CGSize)getCollectionSizeWithCount:(NSInteger)count;
@end
