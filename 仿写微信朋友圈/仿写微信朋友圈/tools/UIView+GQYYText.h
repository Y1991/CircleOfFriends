//
//  UIView+GQYYText.h
//  仿写微信朋友圈
//
//  Created by Guangquan Yu on 2017/11/14.
//  Copyright © 2017年 ZHM.YU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"
@interface UIView (GQYYText)

+ (YYTextLayout *)updateYYLabel:(YYLabel *)yyLabel attributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color colorRanges:(NSArray <NSDictionary *> *)colorRanges alignment:(NSTextAlignment)alignment lineSpacing:(CGFloat)lineSpacing paragraphSpacing:(CGFloat)paragraphSpacing paragraphSpacingBefore:(CGFloat)paragraphSpacingBefore TextLayout:(BOOL)isLabelHeightFixed attributeString:(NSMutableAttributedString *)attributeString maxWidth:(CGFloat)maxWidth yTopOff:(CGFloat)yTopOff isUpdateFrame:(BOOL)isUpdateFrame;

+ (YYTextLayout *)updateYYLabel:(YYLabel *)yyLabel attributedString:(NSMutableAttributedString *)attributedString TextLayout:(BOOL)isLabelHeightFixed maxWidth:(CGFloat)maxWidth yTopOff:(CGFloat)yTopOff isUpdateFrame:(BOOL)isUpdateFrame;

+ (YYLabel *)createYYLabel:(CGRect)frame bgColor:(UIColor *)bgColor font:(UIFont *)font textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode numberOfLines:(NSInteger)numberOfLines text:(NSString *)text;

+ (NSMutableAttributedString *)createAttributedString:(NSString *)string font:(UIFont *)font color:(UIColor *)color colorRanges:(NSArray <NSDictionary *> *)colorRanges alignment:(NSTextAlignment)alignment lineSpacing:(CGFloat)lineSpacing paragraphSpacing:(CGFloat)paragraphSpacing paragraphSpacingBefore:(CGFloat)paragraphSpacingBefore;

+ (NSMutableAttributedString *)createAttributedStringWithImage:(UIImage *)image attachmentSize:(CGSize)attachmentSize font:(UIFont *)font;

+ (YYTextLayout *)createTextLayout:(BOOL)isLabelHeightFixed attributeString:(NSMutableAttributedString *)attributeString maxWidth:(CGFloat)maxWidth yTopOff:(CGFloat)yTopOff view:(UIView *)view isUpdateFrame:(BOOL)isUpdateFrame;

+ (CGSize)yytextSizeWithLayout:(YYTextLayout *)layout;
@end
