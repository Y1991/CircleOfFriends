//
//  YGQ_FC_CommitTableViewCell.m
//  仿写微信朋友圈
//
//  Created by Guangquan Yu on 2017/11/14.
//  Copyright © 2017年 ZHM.YU. All rights reserved.
//

#import "YGQ_FC_CommitTableViewCell.h"
@interface YGQ_FC_CommitTableViewCell ()
@strong_pro YYLabel * commentLabel;

@assign_pro CGFloat maxLabelWidth;
@assign_pro CGFloat labelHight;
@end
@implementation YGQ_FC_CommitTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        self.maxLabelWidth = [UIScreen mainScreen].bounds.size.width-60-20-20;
        [self makeUI];

    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];

}

- (void)makeUI{
    _commentLabel = [UIView createYYLabel:CGRectZero bgColor:[UIColor greenColor] font:[UIFont systemFontOfSize:16] textColor:[UIColor grayColor] alignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByWordWrapping numberOfLines:0 text:@"评论"];
    __weak typeof(self) weakSelf = self;
    _commentLabel.highlightTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
 
        if ([weakSelf.delegate respondsToSelector:@selector(tableViewCell:clickCommentPeronWithName:indexPath:)]) {
            [weakSelf.delegate tableViewCell:weakSelf clickCommentPeronWithName:[text attributedSubstringFromRange:range].string indexPath:weakSelf.indexPath];
        }
    };
    [self.contentView addSubview:_commentLabel];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(60+20+10);
            make.width.equalTo([NSNumber numberWithFloat:([UIScreen mainScreen].bounds.size.width-60-20-20)]);
            make.top.equalTo(self.contentView);
            make.height.equalTo(@200);
    }];
}

-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    NSMutableAttributedString * commentAttributeString = dic[@"commentAttributeString"];
    _labelHight = [dic[@"height"] doubleValue];
    
    [UIView updateYYLabel:_commentLabel attributedString:commentAttributeString TextLayout:NO  maxWidth:_maxLabelWidth yTopOff:0 isUpdateFrame:NO];
    
    [self.commentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:_labelHight]);
    }];

}

+ (NSDictionary *)calculateHeight:(NSDictionary *)dic maxWidth:(CGFloat)maxWidth {
    NSMutableAttributedString * commentAttributeString = [self handleText:dic];
    YYTextLayout * commentLayout = [UIView updateYYLabel:nil attributedString:commentAttributeString TextLayout:NO  maxWidth:maxWidth yTopOff:0 isUpdateFrame:NO];
    CGFloat commentLabelHeight = [UIView yytextSizeWithLayout:commentLayout].height+2;
    
    return @{@"commentAttributeString":commentAttributeString, @"height":[NSString stringWithFormat:@"%f",commentLabelHeight]};
}

+ (NSMutableAttributedString *)handleText:(NSDictionary *)dic{

    NSMutableAttributedString * commentAttributeString = [NSMutableAttributedString new];

    [commentAttributeString appendAttributedString:[UIView createAttributedString:dic[YGQCOMMENTMAN] font:[UIFont systemFontOfSize:16] color:[UIColor blueColor] colorRanges:@[@{@"range":[NSValue valueWithRange:NSMakeRange(0, 2)],
                                                                                                                                                                    @"color":[UIColor blueColor]
                                                                                                                                                                    }] alignment:NSTextAlignmentLeft lineSpacing:0 paragraphSpacing:0 paragraphSpacingBefore:0 ]];
    [self complexityHighlight:commentAttributeString];
    
    if (dic[YGQREVERT]) {
        [commentAttributeString appendAttributedString:[UIView createAttributedString:@"回复" font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] colorRanges:@[@{@"range":[NSValue valueWithRange:NSMakeRange(0, 2)],
                                                                                                                                                                         @"color":[UIColor blackColor]
                                                                                                                                                                         }] alignment:NSTextAlignmentLeft lineSpacing:0 paragraphSpacing:0 paragraphSpacingBefore:0 ]];
        
        NSMutableAttributedString * commentAttributeString1 = [NSMutableAttributedString new];
        [commentAttributeString1 appendAttributedString:[UIView createAttributedString:dic[YGQBYCOMMENTMAN] font:[UIFont systemFontOfSize:16] color:[UIColor blueColor] colorRanges:@[@{@"range":[NSValue valueWithRange:NSMakeRange(0, 0)],
                                                                                                                                                                          @"color":[UIColor blueColor]
                                                                                                                                                                          }] alignment:NSTextAlignmentLeft lineSpacing:0 paragraphSpacing:0 paragraphSpacingBefore:0 ]];
        [self complexityHighlight:commentAttributeString1];
        [commentAttributeString appendAttributedString:commentAttributeString1];
    }

    [commentAttributeString appendAttributedString:[UIView createAttributedString:dic[YGQCONTENT] font:[UIFont systemFontOfSize:16] color:[UIColor blackColor] colorRanges:@[@{@"range":[NSValue valueWithRange:NSMakeRange(0, [dic[YGQCONTENT] length]-1)],
                                                                                                                                                                                                                     @"color":[UIColor redColor]
                                                                                                                                                                                                                     }] alignment:NSTextAlignmentLeft lineSpacing:0 paragraphSpacing:0 paragraphSpacingBefore:0 ]];
    return commentAttributeString;
}

- (CGSize)sizeThatFits:(CGSize)size{
    return CGSizeMake(size.width, _labelHight);
}

+ (void)complexityHighlight:(NSMutableAttributedString *)attributedString{

    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setColor:[UIColor whiteColor]];
    
    YYTextBorder *border = [YYTextBorder borderWithFillColor:[UIColor redColor] cornerRadius:3];
    [highlight setBackgroundBorder:border];

    [attributedString yy_setTextHighlight:highlight range:attributedString.yy_rangeOfAll];
}

@end
