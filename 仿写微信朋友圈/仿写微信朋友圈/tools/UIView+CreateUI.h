//
//  UIView+CreateUI.h
//  NSString方法
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 yugq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonContentDirection) {
    ButtonContentDirection_None =0,
    ButtonContentDirection_Horizontal = 1,
    ButtonContentDirection_Vertical   = 2,
};


@interface UIView (CreateUI)

- (void)removeAllSubviews;

+(UILabel*)makeLabel:(CGRect)frame text:(NSString*)aText textColor:(UIColor*)aColor font:(float)aFont backColor:(UIColor*)aBackColor alignment:(NSTextAlignment)aTextAlignment label:(UILabel *)wLabel;

+(UILabel*) makeLabel:(CGRect)frame backColor:(UIColor*)aBackColor numberOfLines:(NSInteger)numberOfLines;

+ (UIButton *)makeButtonWithNormalImage:(NSString *)normalImageName normalTitle:(NSString *)normalTitle normalColor:(UIColor *)normalColor target:(NSObject *)target action:(SEL)action frame:(CGRect)frame bgColor:(UIColor *)bgColor font:(UIFont *)font selectImage:(NSString *)selectImageName selectTitle:(NSString *)selectTitle selectColor:(UIColor *)selectColor layout:(ButtonContentDirection)direction button:(UIButton *)wButton;

+(UIImageView *)makeImageView:(CGRect)frame imageName:(NSString*)aImageName;

+(UITextField *) makeTextField:(CGRect)frame TextColor:(UIColor *)color textHolder:(NSString *)placeHolder keyBoardType:(UIKeyboardType)keyBoard clearBtn:(UITextFieldViewMode)clearBtnMode textFieldDelegate:(id<UITextFieldDelegate>)tDelegate;

+(UITextView *)makeTextView:(CGRect)frame TextColor:(UIColor *)color Delegate:(id<UITextViewDelegate>)tDelegate;

+ (UIProgressView *)createProgressView:(CGRect)frame style:(UIProgressViewStyle)style tintColor:(UIColor *)tintcolor bgColor:(UIColor*)bgColor;

+ (UISlider *)createSlider:(CGRect)frame target:(NSObject *)target action:(SEL)action tintColor:(UIColor *)tintColor thumbImage:(UIImage *)thumbImage;

+ (UIView *)makeViewWithFrame:(CGRect)frame bgColor:(UIColor*)bgColor view:(UIView *)wView;

+ (UITableView *)makeTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style bgColor:(UIColor*)bgColor Delegate:(id<UITableViewDataSource, UITableViewDelegate>)tDelegate registerClasses:(NSArray<NSString *> *)registerClasses cellReuseIdentifiers:(NSArray<NSString *> *)cellReuseIdentifiers;

@end
