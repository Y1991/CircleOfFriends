//
//  YGQ_FC_CommitTableViewCell.h
//  仿写微信朋友圈
//
//  Created by Guangquan Yu on 2017/11/14.
//  Copyright © 2017年 ZHM.YU. All rights reserved.
//

#import <UIKit/UIKit.h>
#define YGQCOMMENTMAN @"commentMan"
#define YGQREVERT @"revert"
#define YGQBYCOMMENTMAN @"bycommentMan"
#define YGQCONTENT @"content"

@class YGQ_FC_CommitTableViewCell;
@protocol YGQ_FC_CommitTableViewCellDelegate <NSObject>

@required

// 评论
- (void)tableViewCell:(YGQ_FC_CommitTableViewCell *_Nullable)cell clickCommentPeronWithName:(NSString *_Nullable)name indexPath:(NSIndexPath *_Nullable)indexPath ;

@optional

@end
@interface YGQ_FC_CommitTableViewCell : UITableViewCell
/**< 代理 */
@property (nonatomic, weak, nullable) id<YGQ_FC_CommitTableViewCellDelegate> delegate;
@property (nonatomic, copy, nullable) NSIndexPath * indexPath;

@strong_pro NSDictionary * _Nullable dic;

+ (NSDictionary *_Nullable)calculateHeight:(NSDictionary *_Nullable)dic maxWidth:(CGFloat)maxWidth;
@end
