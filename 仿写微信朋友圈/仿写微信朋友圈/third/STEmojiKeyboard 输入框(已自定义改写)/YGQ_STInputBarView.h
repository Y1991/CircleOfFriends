//
//  YGQ_STInputBarView.h
//  Keyboard
//
//  Created by Guangquan Yu on 2017/11/21.
//  Copyright © 2017年 ZHM.YU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGQ_STInputBarView : UIView

- (void)addToWindowWithScrollView:(UIScrollView *)scrollView relativeView:(UIView *)relativeView kbScrollInsetBlock:(void(^)(UIEdgeInsets insets))kbScrollInsetBlock kbScrollOffsetBlock:(void(^)(CGPoint point))kbScrollOffsetBlock updateMessageBlock:(void(^)(NSString * message, NSString * placeHolder))updateMessageBlock placeHolder:(NSString *)placeHolder;


@property(nonatomic,copy)void(^sureBlock)(NSInteger index);
@property(nonatomic,copy)void(^dismissBlock)(void);
@end
