//
//  YGQ_FC_TableViewCell.h
//  仿写微信朋友圈
//
//  Created by Guangquan Yu on 2017/11/13.
//  Copyright © 2017年 ZHM.YU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGQ_FriendCircleImageDisplayNew.h"

@class YGQ_FC_TableViewCell;
@protocol YGQ_FC_TableViewCellDelegate <NSObject>
@required
- (void)tableViewCell:(YGQ_FC_TableViewCell *_Nullable)cell clickSpeakMoreButton:(BOOL)isOpen indexPath:(NSIndexPath *_Nullable)indexPath;

- (void)tableViewCell:(YGQ_FC_TableViewCell *_Nullable)cell clickCommentButtonWithIndexPath:(NSIndexPath *_Nullable)indexPath;

- (void)tableViewCell:(YGQ_FC_TableViewCell *_Nullable)cell clickPraiseButtonWithIndexPath:(NSIndexPath *_Nullable)indexPath;
@optional

@end

@interface YGQ_FC_TableViewCell : UITableViewCell

@property (nonatomic, weak, nullable) id<YGQ_FC_TableViewCellDelegate> delegate;
@property (nonatomic, copy, nullable) NSIndexPath * indexPath;

- (void)loadData:(NSDictionary *_Nullable)dic;
+ (NSDictionary *_Nullable)calculateHeight:(NSDictionary *_Nullable)dic maxWidth:(CGFloat)maxWidth;

@end
