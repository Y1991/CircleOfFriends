//
//  UIView+GQYYText.m
//  仿写微信朋友圈
//
//  Created by Guangquan Yu on 2017/11/14.
//  Copyright © 2017年 ZHM.YU. All rights reserved.
//

#import "UIView+GQYYText.h"

@implementation UIView (GQYYText)

+ (YYTextLayout *)updateYYLabel:(YYLabel *)yyLabel attributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color colorRanges:(NSArray <NSDictionary *> *)colorRanges alignment:(NSTextAlignment)alignment lineSpacing:(CGFloat)lineSpacing paragraphSpacing:(CGFloat)paragraphSpacing paragraphSpacingBefore:(CGFloat)paragraphSpacingBefore TextLayout:(BOOL)isLabelHeightFixed attributeString:(NSMutableAttributedString *)attributeString maxWidth:(CGFloat)maxWidth yTopOff:(CGFloat)yTopOff isUpdateFrame:(BOOL)isUpdateFrame{
    NSMutableAttributedString * attributedString = [UIView createAttributedString:string font:font color:color
                                                                      colorRanges:colorRanges alignment:alignment lineSpacing:lineSpacing paragraphSpacing:paragraphSpacing paragraphSpacingBefore:paragraphSpacingBefore];
    
    YYTextLayout * layout = [UIView createTextLayout:isLabelHeightFixed attributeString:attributedString maxWidth:maxWidth yTopOff:yTopOff view:yyLabel  isUpdateFrame:isUpdateFrame];
    
    if (yyLabel) {
        yyLabel.attributedText = attributedString;
        yyLabel.textLayout = layout;
    }
    
    
    return layout;
}

+ (YYTextLayout *)updateYYLabel:(YYLabel *)yyLabel attributedString:(NSMutableAttributedString *)attributedString TextLayout:(BOOL)isLabelHeightFixed maxWidth:(CGFloat)maxWidth yTopOff:(CGFloat)yTopOff isUpdateFrame:(BOOL)isUpdateFrame{
    YYTextLayout * layout = [UIView createTextLayout:isLabelHeightFixed attributeString:attributedString maxWidth:maxWidth yTopOff:yTopOff view:yyLabel  isUpdateFrame:isUpdateFrame];
    
    if (yyLabel) {
        yyLabel.attributedText = attributedString;
        yyLabel.textLayout = layout;
    }
    
    return layout;
}

+ (YYLabel *)createYYLabel:(CGRect)frame bgColor:(UIColor *)bgColor font:(UIFont *)font textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode numberOfLines:(NSInteger)numberOfLines text:(NSString *)text{
    
    YYLabel *label = [YYLabel new];
    label.backgroundColor = bgColor;

    label.frame = frame;
    
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = alignment;
    label.lineBreakMode = lineBreakMode;
    label.numberOfLines = numberOfLines;

    label.text = text;
    
    return label;
}

+ (NSMutableAttributedString *)createAttributedString:(NSString *)string font:(UIFont *)font color:(UIColor *)color colorRanges:(NSArray <NSDictionary *> *)colorRanges alignment:(NSTextAlignment)alignment lineSpacing:(CGFloat)lineSpacing paragraphSpacing:(CGFloat)paragraphSpacing paragraphSpacingBefore:(CGFloat)paragraphSpacingBefore{
    
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:string];
    
    text.yy_font = font;
    text.yy_color = color;
    for (NSDictionary * dic in colorRanges) {
        NSValue * rangeV = dic[@"range"] ;
        NSRange r = [rangeV rangeValue];
        UIColor * c = dic[@"color"];
        [text yy_setColor:c range:r];
    }
    
    text.yy_alignment = alignment;
    text.yy_lineSpacing = lineSpacing;
    text.yy_paragraphSpacing = paragraphSpacing;
    text.yy_paragraphSpacingBefore = paragraphSpacingBefore;
    
    return text;
}

+ (YYTextLayout *)createTextLayout:(BOOL)isLabelHeightFixed attributeString:(NSMutableAttributedString *)attributeString maxWidth:(CGFloat)maxWidth yTopOff:(CGFloat)yTopOff view:(UIView *)view isUpdateFrame:(BOOL)isUpdateFrame{
    
    if (isLabelHeightFixed) {
        
        CGSize size = CGSizeMake(maxWidth, CGFLOAT_MAX);
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:attributeString];
        
        if (view) {
            
            CGSize size_ = layout.textBoundingSize;

            UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
            
            float offy = 0;
            offy = (view.frame.size.height-size_.height-yTopOff);
            if (offy>=0) {
                inset = UIEdgeInsetsMake(yTopOff, 0, offy, 0);
            } else {
                inset = UIEdgeInsetsMake(-offy, 0, 0, 0);
            }
           
            YYTextContainer *container = [YYTextContainer containerWithSize:size insets:inset];
            YYTextLayout *layout_update = [YYTextLayout layoutWithContainer:container text:attributeString];

            return layout_update;
        }
        
        return layout;
        
    } else {

        CGSize size = CGSizeMake(maxWidth, CGFLOAT_MAX);
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:attributeString];
        
        if (view&&isUpdateFrame) {

            CGSize size_ ;
            size_ = layout.textBoundingSize; 

            CGRect temp = view.frame;
            temp.size.height = size_.height;
            view.frame = temp;
        }
        
        return layout;
    }
}

+ (CGSize)yytextSizeWithLayout:(YYTextLayout *)layout{
    return layout.textBoundingSize;
}

+ (NSMutableAttributedString *)createAttributedStringWithImage:(UIImage *)image attachmentSize:(CGSize)attachmentSize font:(UIFont *)font{
    NSMutableAttributedString *attachment = nil;

    attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image
                                                               contentMode:UIViewContentModeCenter
                                                            attachmentSize:attachmentSize
                                                               alignToFont:font
                                                                 alignment:YYTextVerticalAlignmentCenter];
    return attachment;
    
}
@end
