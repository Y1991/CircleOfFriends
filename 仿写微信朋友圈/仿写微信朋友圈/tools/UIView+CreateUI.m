//
//  UIView+CreateUI.m
//  NSString方法
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 yugq. All rights reserved.
//

#import "UIView+CreateUI.h"

@implementation UIView (CreateUI)

- (void)removeAllSubviews
{
    NSArray * array = [self.subviews copy];
    
    for (UIView * view in array){
        
        [view removeFromSuperview];
    }
}

+(UILabel*)makeLabel:(CGRect)frame text:(NSString*)aText textColor:(UIColor*)aColor font:(float)aFont backColor:(UIColor*)aBackColor alignment:(NSTextAlignment)aTextAlignment label:(UILabel *)wLabel
{
    UILabel *label = wLabel;
    if (!label) {
        label = [[UILabel alloc]init];
    }
  
    //frame
    if (!CGRectEqualToRect(frame, CGRectZero)) {
        label.frame = frame;
    }
    
    if (aText) {
        label.text = aText;
    }
    
    label.textAlignment = aTextAlignment;
    
    if (aBackColor) {
        label.backgroundColor = aBackColor;
    }
    
    if (aColor) {
        label.textColor = aColor;
    }
    
    if (aFont) {
        label.font = [UIFont systemFontOfSize:aFont];
    }
    
    return label;
}

+(UILabel*) makeLabel:(CGRect)frame backColor:(UIColor*)aBackColor numberOfLines:(NSInteger)numberOfLines{
    UILabel *label  = [[UILabel alloc]initWithFrame:frame];
    label.backgroundColor = aBackColor;
    label.numberOfLines = numberOfLines;
    return label;
}

+ (UIButton *)makeButtonWithNormalImage:(NSString *)normalImageName normalTitle:(NSString *)normalTitle normalColor:(UIColor *)normalColor target:(NSObject *)target action:(SEL)action frame:(CGRect)frame bgColor:(UIColor *)bgColor font:(UIFont *)font selectImage:(NSString *)selectImageName selectTitle:(NSString *)selectTitle selectColor:(UIColor *)selectColor layout:(ButtonContentDirection)direction button:(UIButton *)wButton
{
    UIButton *button = wButton;
    if (!button) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    if (normalImageName) {
        [button setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    }
    if (normalTitle) {
        [button setTitle:normalTitle forState:UIControlStateNormal];
    }
    if (normalColor) {
        [button setTitleColor:normalColor forState:UIControlStateNormal];
    }

    if (action&&target) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }

    if (!CGRectEqualToRect(frame, CGRectZero)) {
        button.frame = frame;
    }

    if (bgColor) {
        button.backgroundColor = bgColor;
    }

    if (font.pointSize) {
        button.titleLabel.font = font;
    }
 
    if (selectImageName) {
        [button setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    }
    if (selectTitle) {
        [button setTitle:selectTitle forState:UIControlStateSelected];
    }
    if (selectColor) {
        [button setTitleColor:selectColor forState:UIControlStateSelected];
    }

    if (normalImageName) {

    UIImage *image = [UIImage imageNamed:normalImageName];

    float imgW = image.size.width;

    float imgH = image.size.height;

    float fontSize = font.pointSize;

    CGRect tRect = [normalTitle boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width,CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                                       context:nil];

    float tW = CGRectGetWidth(tRect);

    float tH = CGRectGetHeight(tRect);

    float btnMgnVer = 0;

    float btnMgnHor = 0;

    float itGap = 2;

    if (direction == ButtonContentDirection_Vertical) {

        
         float btnW = MAX(tW, imgW);
         btnW = MAX(btnW+btnMgnHor*2, CGRectGetWidth(frame));
         float btnH = MAX(imgH+tH+btnMgnVer*2+itGap, CGRectGetHeight(frame));

         button.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), btnW, btnH );
         [button setImageEdgeInsets:UIEdgeInsetsMake(-(tH+itGap)/2.0     ,  0     ,
         (tH+itGap)/2.0     , -tW     )];
         [button setTitleEdgeInsets:UIEdgeInsetsMake( (imgH+itGap)/2.0   , -imgW   ,
         -(imgH+itGap)/2.0   ,  0   )];

    } else if (direction == ButtonContentDirection_Horizontal) {
        
        float btnW = MAX(tW+imgW+btnMgnHor*2+itGap, CGRectGetWidth(frame));

        float btnH = MAX(tH+btnMgnVer*2, imgH+btnMgnVer*2);
        btnH = btnH>CGRectGetHeight(frame)?:CGRectGetHeight(frame);

        button.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), btnW, btnH);
        [button setImageEdgeInsets:UIEdgeInsetsMake(0       ,  (tW+itGap)     ,
                                                    0       , -(tW+itGap)     )];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0       , -(imgW+itGap)   ,
                                                    0       ,  (imgW+itGap)   )];
  
    }else{}
   

    }
    return button;
}

+(UITextField *) makeTextField:(CGRect)frame TextColor:(UIColor *)color textHolder:(NSString *)placeHolder keyBoardType:(UIKeyboardType)keyBoard clearBtn:(UITextFieldViewMode)clearBtnMode textFieldDelegate:(id<UITextFieldDelegate>)tDelegate
{
    UITextField *text = [[UITextField alloc] initWithFrame:frame];
    text.delegate = tDelegate;
    text.placeholder = placeHolder;
    text.borderStyle = UITextBorderStyleNone;
    text.keyboardType = keyBoard;
    text.clearButtonMode = clearBtnMode;
    text.textColor = color;
    text.textAlignment = NSTextAlignmentCenter;
    text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    text.returnKeyType = UIReturnKeyDone;
    return text;
}

+(UITextView *)makeTextView:(CGRect)frame TextColor:(UIColor *)color Delegate:(id<UITextViewDelegate>)tDelegate
{
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    textView.delegate = tDelegate;
    textView.textColor = color;
    textView.font = [UIFont systemFontOfSize:17];
    textView.showsHorizontalScrollIndicator = NO;
    textView.showsVerticalScrollIndicator = NO;
    return textView;
}

+(UIImageView *)makeImageView:(CGRect)frame imageName:(NSString*)aImageName
{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.userInteractionEnabled = YES;
    [imageView setImage:[UIImage imageNamed:aImageName]];
    return imageView;
}

+ (UIView *)makeViewWithFrame:(CGRect)frame bgColor:(UIColor*)bgColor view:(UIView *)wView
{
    UIView *view = wView;
    if (!view) {
        view = [[UIView alloc]init];
    }

    if (!CGRectEqualToRect(frame, CGRectZero)) {
        view.frame = frame;
    }
    if (bgColor) {
        view.backgroundColor = bgColor;
    }
    return view;
}

+ (UITableView *)makeTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style bgColor:(UIColor*)bgColor Delegate:(id<UITableViewDataSource, UITableViewDelegate>)tDelegate registerClasses:(NSArray<NSString *> *)registerClasses cellReuseIdentifiers:(NSArray<NSString *> *)cellReuseIdentifiers{
    
        UITableView * tableV = [[UITableView alloc]initWithFrame:frame style:style];
        if (@available(iOS 11.0, *)) {
            tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        tableV.dataSource = tDelegate;
        tableV.delegate = tDelegate;
        tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
        NSInteger count = registerClasses.count<cellReuseIdentifiers.count?registerClasses.count:cellReuseIdentifiers.count;
        for (int i=0; i<count; i++) {
            [tableV registerClass:NSClassFromString(registerClasses[i]) forCellReuseIdentifier:cellReuseIdentifiers[i]];
        }
        
        tableV.estimatedRowHeight = 10;
        tableV.estimatedSectionHeaderHeight = 0;
        tableV.estimatedSectionFooterHeight = 0;
        
        if ([tableV respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableV setSeparatorInset:UIEdgeInsetsZero];
            
        }
        if ([tableV respondsToSelector:@selector(setLayoutMargins:)])  {
            [tableV setLayoutMargins:UIEdgeInsetsZero];
        }
        tableV.backgroundColor = bgColor;
    return tableV;
}


@end
