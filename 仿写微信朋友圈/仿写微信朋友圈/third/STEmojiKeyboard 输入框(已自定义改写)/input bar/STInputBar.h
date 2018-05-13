//
//  STInputBar.h
//  STEmojiKeyboard
//
//  Created by zhenlintie on 15/5/29.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STInputBar : UIView

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIView *relativeView;
@property (copy, nonatomic) void(^kbScrollInsetBlock)(UIEdgeInsets insets) ;
@property (copy, nonatomic) void(^kbScrollOffsetBlock)(CGPoint point) ;
@property (copy, nonatomic) void(^updateMessageBlock)(NSString * message, NSString * placeHolder) ;

+ (instancetype)inputBar;

@property (assign, nonatomic) BOOL fitWhenKeyboardShowOrHide;

@property (copy, nonatomic) NSString *placeHolder;

- (void)setInputBarSizeChangedHandle:(void(^)(void))handler;

@end
