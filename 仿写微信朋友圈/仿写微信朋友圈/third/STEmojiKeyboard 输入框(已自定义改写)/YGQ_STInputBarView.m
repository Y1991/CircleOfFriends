//
//  YGQ_STInputBarView.m
//  Keyboard
//
//  Created by Guangquan Yu on 2017/11/21.
//  Copyright © 2017年 ZHM.YU. All rights reserved.
//

#import "YGQ_STInputBarView.h"
#import "STInputBar.h"

@interface YGQ_STInputBarView ()
@property (nonatomic, strong)STInputBar * inputBar;

@end
@implementation YGQ_STInputBarView

- (void)addToWindowWithScrollView:(UIScrollView *)scrollView relativeView:(UIView *)relativeView kbScrollInsetBlock:(void(^)(UIEdgeInsets insets))kbScrollInsetBlock kbScrollOffsetBlock:(void(^)(CGPoint point))kbScrollOffsetBlock updateMessageBlock:(void(^)(NSString * message, NSString * placeHolder))updateMessageBlock placeHolder:(NSString *)placeHolder{

    _inputBar.kbScrollInsetBlock = kbScrollInsetBlock;
    _inputBar.kbScrollOffsetBlock = kbScrollOffsetBlock;
    __weak __typeof(self) weakSelf = self;
    _inputBar.updateMessageBlock = ^(NSString * message, NSString * placeHolder){
        [weakSelf dismiss];
        if (updateMessageBlock) {
            updateMessageBlock(message, placeHolder);
        }
    };
    
    _inputBar.placeHolder = placeHolder;
    _inputBar.scrollView = scrollView;
    _inputBar.relativeView = relativeView;
    [[[UIApplication sharedApplication] delegate].window addSubview:self];
    [_inputBar becomeFirstResponder];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    _inputBar = [STInputBar inputBar];
    _inputBar.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.bounds)-CGRectGetHeight(_inputBar.frame)+CGRectGetHeight(_inputBar.frame)/2);
    [_inputBar setFitWhenKeyboardShowOrHide:YES];
    _inputBar.placeHolder = @"...";
    [self addSubview:_inputBar];
    _inputBar.hidden = YES;
 
    [_inputBar setInputBarSizeChangedHandle:^{

    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

        [self dismiss];

}

- (void)dismiss{
    [_inputBar resignFirstResponder];
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
 
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];

        
    }];
}

@end
