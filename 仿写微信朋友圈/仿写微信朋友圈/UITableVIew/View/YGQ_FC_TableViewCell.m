//
//  YGQ_FC_TableViewCell.m
//  仿写微信朋友圈
//
//  Created by Guangquan Yu on 2017/11/13.
//  Copyright © 2017年 ZHM.YU. All rights reserved.
//

#import "YGQ_FC_TableViewCell.h"
#import "SDTimeLineCellOperationMenu.h"
NSString *const kSDTimeLineCellOperationButtonClickedNotification = @"SDTimeLineCellOperationButtonClickedNotification";

@interface YGQ_FC_TableViewCell ()
@strong_pro UIImageView * headImgV;
@strong_pro YYLabel * nicknameLabel;
@strong_pro YYLabel * speakcontentLabel;
@strong_pro UIButton * speakMoreButton;
@strong_pro YGQ_FriendCircleImageDisplayNew * imageDisplay;
@strong_pro YYLabel * descriptionInfoLabel;
@strong_pro UIButton * commentButton;
@strong_pro SDTimeLineCellOperationMenu * commentMenu;
@strong_pro YYLabel * praiseLabel;
@assign_pro CGFloat nicknameLabelWidth;
@strong_pro NSDictionary * dataDic;

@end
@implementation YGQ_FC_TableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        self.nicknameLabelWidth = [UIScreen mainScreen].bounds.size.width-60-20-20;
        [self makeUI];
        [self createNotificationForHidecommentMenu];

    }
    return self;
}

- (void)makeUI{
    [self.contentView addSubview:self.headImgV];
    [self.contentView addSubview:self.nicknameLabel];
    [self.contentView addSubview:self.speakcontentLabel];
    [self.contentView addSubview:self.speakMoreButton];
    [self.contentView addSubview:self.imageDisplay];
    [self.contentView addSubview:self.descriptionInfoLabel];
    [self.contentView addSubview:self.commentButton];
    [self.contentView addSubview:self.commentMenu];
    [self.contentView addSubview:self.praiseLabel];
    
    [self.headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImgV.mas_top);
        make.left.equalTo(self.headImgV.mas_right).offset(10);
        make.width.equalTo([NSNumber numberWithFloat:self.nicknameLabelWidth]);
        //make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [self.speakcontentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.headImgV.mas_right).offset(10);
        make.width.equalTo([NSNumber numberWithFloat:self.nicknameLabelWidth]);
    }];
    [self.speakMoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.speakcontentLabel.mas_bottom).offset(0);
        make.left.equalTo(self.headImgV.mas_right).offset(10);
        make.width.equalTo([NSNumber numberWithFloat:60]);
        make.height.equalTo([NSNumber numberWithFloat:30]);
    }];
    [self.imageDisplay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.speakMoreButton.mas_bottom).offset(5);
        make.left.equalTo(self.headImgV.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    [self.descriptionInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageDisplay.mas_bottom).offset(5);
        make.left.equalTo(self.headImgV.mas_right).offset(10);
        make.width.equalTo([NSNumber numberWithFloat:self.nicknameLabelWidth]);
    }];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.descriptionInfoLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.commentMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commentButton.mas_centerY);
        make.right.equalTo(self.commentButton.mas_left).offset(0);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(0);
    }];
    [self.praiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionInfoLabel.mas_bottom).offset(5);
        make.left.equalTo(self.headImgV.mas_right).offset(10);
        make.width.equalTo([NSNumber numberWithFloat:self.nicknameLabelWidth]);
    }];

}

- (void)loadData:(NSDictionary *)dic{
    _dataDic = dic;
    if (_commentMenu.isShowing) {
        _commentMenu.show = NO;
    }
    
    [UIView updateYYLabel:_nicknameLabel attributedString:dic[@"nicknameLabel"][@"attributedString"] TextLayout:NO maxWidth:_nicknameLabelWidth yTopOff:0 isUpdateFrame:NO];
    CGFloat nicknameLabelHeight = [dic[@"nicknameLabel"][@"height"] doubleValue];
    [self.nicknameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:nicknameLabelHeight]);
    }];

    CGFloat speakcontentLabelHeight = 0;
    CGFloat speakMoreTop = 0;
    CGFloat speakMoreHeight = 0;
    BOOL isLabelHeightFixed = NO;
    if ([dic[@"speakcontentLabel"][@"isShowMoreButton"] boolValue]) {
        speakMoreTop = 5;
        speakMoreHeight = 30;
        if ([dic[@"speakcontentLabel"][@"isOpening"] boolValue]) {
            [self.speakMoreButton setTitle:@"收起" forState:UIControlStateNormal];
            speakcontentLabelHeight = [dic[@"speakcontentLabel"][@"height"] doubleValue];
        } else {
            isLabelHeightFixed = YES;
            [self.speakMoreButton setTitle:@"全文" forState:UIControlStateNormal];
            speakcontentLabelHeight = [dic[@"speakcontentLabel"][@"limitHeight"] doubleValue];
        }
    } else {
        speakMoreTop = 0;
        speakMoreHeight = 0;
        speakcontentLabelHeight = [dic[@"speakcontentLabel"][@"height"] doubleValue];
    }
    
    [self.speakcontentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:speakcontentLabelHeight]);
    }];

    [_speakcontentLabel layoutIfNeeded];
    [_speakcontentLabel setNeedsLayout];
    [UIView updateYYLabel:_speakcontentLabel attributedString:dic[@"speakcontentLabel"][@"attributedString"] TextLayout:isLabelHeightFixed maxWidth:_nicknameLabelWidth yTopOff:0 isUpdateFrame:NO];
    
    [self.speakMoreButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.speakcontentLabel.mas_bottom).offset(speakMoreTop);
        make.height.equalTo([NSNumber numberWithFloat:speakMoreHeight]);
    }];

    _imageDisplay.countDic = dic[@"ImageDisplay"];//赋值
    CGSize collectionSize = [dic[@"ImageDisplay"][@"collectionSize"] CGSizeValue];
    [self.imageDisplay mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([NSNumber numberWithFloat:collectionSize.width]);
        make.height.equalTo([NSNumber numberWithFloat:collectionSize.height]);
    }];
    
    [UIView updateYYLabel:_descriptionInfoLabel attributedString:dic[@"descriptionInfoLabel"][@"attributedString"] TextLayout:NO maxWidth:_nicknameLabelWidth yTopOff:0 isUpdateFrame:NO];
    CGFloat descriptionInfoLabelHeight = [dic[@"descriptionInfoLabel"][@"height"] doubleValue];
    [self.descriptionInfoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:descriptionInfoLabelHeight]);
    }];

    [UIView updateYYLabel:_praiseLabel attributedString:dic[@"praiseLabel"][@"attributedString"] TextLayout:NO maxWidth:_nicknameLabelWidth yTopOff:0 isUpdateFrame:NO];

    CGFloat praiseLabelHeight = [dic[@"praiseLabel"][@"height"] doubleValue];
    [self.praiseLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:praiseLabelHeight]);
    }];
}

+ (NSDictionary *)calculateHeight:(NSDictionary *)dic maxWidth:(CGFloat)maxWidth{
    NSMutableDictionary * mudic =dic.mutableCopy;
    
    CGFloat allHeight = 0;
    allHeight += 20;
    NSMutableAttributedString * nicknameAttributedString = [UIView createAttributedString:@"豫光涴涱" font:[UIFont boldSystemFontOfSize:25] color:[UIColor blueColor]
                                                                      colorRanges:@[@{@"range":[NSValue valueWithRange:NSMakeRange(1, 1)],
                                                                                      @"color":[UIColor redColor]
                                                                                      }] alignment:NSTextAlignmentLeft lineSpacing:0 paragraphSpacing:0 paragraphSpacingBefore:0];
    YYTextLayout * nicknameLayout = [UIView createTextLayout:NO attributeString:nicknameAttributedString maxWidth:maxWidth yTopOff:0 view:nil isUpdateFrame:NO];
    CGFloat nicknameLabelHeight = [UIView yytextSizeWithLayout:nicknameLayout].height;
    allHeight += nicknameLabelHeight;
    [mudic addEntriesFromDictionary:@{@"nicknameLabel":@{@"height":[NSString stringWithFormat:@"%f",nicknameLabelHeight],
                                                @"attributedString":nicknameAttributedString},
                                      }];
    allHeight += 5;
    NSMutableAttributedString * speakcontentAttributedString = [UIView createAttributedString:@"明年智能手机的设计走向依旧会跟随全面屏的大潮。这种现实对比让“90后”在与世界打交道时更自信，同时对西方世界对中国的偏见表示不满。采访中，70%的“90后”认同“西方国家总是用双重标准来责难中国”，近80%的人认同“中国不需要实行西方的制度也能越来越好”。" font:[UIFont boldSystemFontOfSize:25] color:[UIColor blackColor]
                                                                              colorRanges:@[@{@"range":[NSValue valueWithRange:NSMakeRange(4, 4)],
                                                                                              @"color":[UIColor redColor]
                                                                                              }] alignment:NSTextAlignmentLeft lineSpacing:0 paragraphSpacing:0 paragraphSpacingBefore:0];
    YYTextLayout * speakcontentLayout = [UIView createTextLayout:NO attributeString:speakcontentAttributedString maxWidth:maxWidth yTopOff:0 view:nil isUpdateFrame:NO];
    CGFloat speakcontentLabelHeight = [UIView yytextSizeWithLayout:speakcontentLayout].height;
    allHeight += speakcontentLabelHeight;
    CGFloat speakcontentlimitHeight = 56;
    bool isShowMoreButton = speakcontentLabelHeight>speakcontentlimitHeight?true:false;
    [mudic addEntriesFromDictionary:@{@"speakcontentLabel":@{@"height":[NSString stringWithFormat:@"%f",speakcontentLabelHeight],
                                                         @"attributedString":speakcontentAttributedString,
                                                             
                                                             @"isShowMoreButton":[NSNumber numberWithBool:isShowMoreButton],
                                                             @"limitHeight":[NSNumber numberWithFloat:speakcontentlimitHeight],
                                                             @"isOpening":[NSNumber numberWithBool:false]
                                                             },
                                      }];
    allHeight += 5;
    CGSize ImageDisplaySize = [YGQ_FriendCircleImageDisplayNew getCollectionSizeWithCount:[dic[@"图片Count"] integerValue]];
    allHeight += ImageDisplaySize.height;
    [mudic addEntriesFromDictionary:@{@"ImageDisplay":@{@"count":[NSString stringWithFormat:@"%ld",[dic[@"图片Count"] integerValue]],
                                                        @"dataArr":dic[@"图片Data"],
                                                             @"collectionSize":[NSValue valueWithCGSize:ImageDisplaySize]},
                                      }];
    allHeight += 5;
    NSMutableAttributedString * descriptionInfoAttributedString = [UIView createAttributedString:@"沈阳\n一天前" font:[UIFont systemFontOfSize:16] color:[UIColor grayColor]
                                                                                  colorRanges:@[@{@"range":[NSValue valueWithRange:NSMakeRange(0, 2)],
                                                                                                  @"color":[UIColor blueColor]
                                                                                                  }] alignment:NSTextAlignmentLeft lineSpacing:0 paragraphSpacing:0 paragraphSpacingBefore:0];
    YYTextLayout * descriptionInfoLayout = [UIView createTextLayout:NO attributeString:descriptionInfoAttributedString maxWidth:maxWidth yTopOff:0 view:nil isUpdateFrame:NO];
    CGFloat descriptionInfoLabelHeight = [UIView yytextSizeWithLayout:descriptionInfoLayout].height+3;
    allHeight += descriptionInfoLabelHeight;
    [mudic addEntriesFromDictionary:@{@"descriptionInfoLabel":@{@"height":[NSString stringWithFormat:@"%f",descriptionInfoLabelHeight],
                                                             @"attributedString":descriptionInfoAttributedString},
                                      }];
    
    allHeight += 5;
    NSMutableAttributedString * praiseAttributeString = [UIView createAttributedStringWithImage:[UIImage imageNamed:@"praise_select.png"] attachmentSize:CGSizeMake(50, 30) font:[UIFont systemFontOfSize:12]];
    [praiseAttributeString appendAttributedString:[UIView createAttributedString:@"小明明，立方，晴天" font:[UIFont systemFontOfSize:16] color:[UIColor grayColor] colorRanges:@[@{@"range":[NSValue valueWithRange:NSMakeRange(0, 2)],
                                                                                                                                                                          @"color":[UIColor blueColor]
                                                                                                                                                                          }] alignment:NSTextAlignmentLeft lineSpacing:2 paragraphSpacing:0 paragraphSpacingBefore:0 ]];
    YYTextLayout * praiseLayout = [UIView createTextLayout:NO attributeString:praiseAttributeString maxWidth:maxWidth yTopOff:0 view:nil isUpdateFrame:NO];
    CGFloat praiseLabelHeight = [UIView yytextSizeWithLayout:praiseLayout].height;
    allHeight += praiseLabelHeight;
    [mudic addEntriesFromDictionary:@{@"praiseLabel":@{@"height":[NSString stringWithFormat:@"%f",praiseLabelHeight],
                                                                @"attributedString":praiseAttributeString},
                                      }];
    allHeight += 5;
    NSString * pinglunHeight = dic[@"commentsH"];
    allHeight += [pinglunHeight doubleValue];
    [mudic addEntriesFromDictionary:@{@"commentDisplay":@{@"height":pinglunHeight,
                                                       @"dataArr":dic[@"commentsContent"]},
                                      }];
    [mudic addEntriesFromDictionary:@{@"cellOneHeight":[NSString stringWithFormat:@"%f",allHeight-[pinglunHeight doubleValue]]}];
    if (isShowMoreButton) {
        CGFloat buttonHeight = (5+30);
        [mudic addEntriesFromDictionary:@{@"limitCellOneHeight_NoOpen":[NSString stringWithFormat:@"%f",allHeight-[pinglunHeight doubleValue] -speakcontentLabelHeight +speakcontentlimitHeight +buttonHeight]}];
        [mudic addEntriesFromDictionary:@{@"limitCellOneHeight_Open":[NSString stringWithFormat:@"%f",[mudic[@"cellOneHeight"] doubleValue] +buttonHeight]}];
    }

    [mudic addEntriesFromDictionary:@{@"cellTwoHeight":[NSString stringWithFormat:@"%f",[pinglunHeight doubleValue]]}];
    return mudic;
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    __weak typeof(self) weakSelf = self;

    [_commentMenu setLikeButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(tableViewCell:clickPraiseButtonWithIndexPath:)]) {
            [weakSelf.delegate tableViewCell:weakSelf clickPraiseButtonWithIndexPath:weakSelf.indexPath];
        }
    }];
    
    [_commentMenu setCommentButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(tableViewCell:clickCommentButtonWithIndexPath:)]) {
            [weakSelf.delegate tableViewCell:weakSelf clickCommentButtonWithIndexPath:weakSelf.indexPath];
        }
    }];
}

-(void)commentButtonClick:(UIButton *)button {
    [self postOperationButtonClickedNotification];
    _commentMenu.show = !_commentMenu.isShowing;
    self.commentMenu.show = YES;
}

-(void)speakMoreButtonClick:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(tableViewCell:clickSpeakMoreButton:indexPath:)]) {
        BOOL isOpen = NO;
        if ([button.titleLabel.text isEqualToString:@"全文"]) {
            isOpen = YES;
        }

        [_delegate tableViewCell:self clickSpeakMoreButton:isOpen indexPath:self.indexPath];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self postOperationButtonClickedNotification];
    if (_commentMenu.isShowing) {
        _commentMenu.show = NO;
    }
}

- (void)createNotificationForHidecommentMenu{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:kSDTimeLineCellOperationButtonClickedNotification object:nil];
}

- (void)receiveOperationButtonClickedNotification:(NSNotification *)notification
{
    UIButton *btn = [notification object];
    
    if (btn != _commentButton && _commentMenu.isShowing) {
        _commentMenu.show = NO;
    }
}

- (void)postOperationButtonClickedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSDTimeLineCellOperationButtonClickedNotification object:_commentButton];
}

lazyloading_implementation(UIImageView *, headImgV,
                           
                           _headImgV = [UIView makeImageView:CGRectZero imageName:@"白玫瑰.jpg"];
                           )

lazyloading_implementation(YYLabel *, nicknameLabel,
                           
                           _nicknameLabel = [UIView createYYLabel:CGRectZero bgColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:20] textColor:[UIColor redColor] alignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByWordWrapping numberOfLines:0 text:@"昵称"];
                           )
lazyloading_implementation(YYLabel *, speakcontentLabel,
                           
                           _speakcontentLabel = [UIView createYYLabel:CGRectZero bgColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:20] textColor:[UIColor redColor] alignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByWordWrapping numberOfLines:0 text:@"说说"];
                           )
lazyloading_implementation(UIButton *, speakMoreButton,
                           
                           _speakMoreButton = [UIView makeButtonWithNormalImage:nil normalTitle:@"显示更多" normalColor:[UIColor blueColor] target:self action:@selector(speakMoreButtonClick:) frame:CGRectZero bgColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] selectImage:nil selectTitle:nil selectColor:nil layout:0 button:nil];
                           
                           )
lazyloading_implementation(YGQ_FriendCircleImageDisplayNew *, imageDisplay,
                           
                           _imageDisplay = [[YGQ_FriendCircleImageDisplayNew alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
                           
                           )
lazyloading_implementation(YYLabel *, descriptionInfoLabel,
                           
                           _descriptionInfoLabel = [UIView createYYLabel:CGRectZero bgColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] textColor:[UIColor grayColor] alignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByWordWrapping numberOfLines:0 text:@"描述信息"];
                           
                           )
lazyloading_implementation(UIButton *, commentButton,
                           
                           _commentButton = [UIView makeButtonWithNormalImage:@"comment.png" normalTitle:@"" normalColor:nil target:self action:@selector(commentButtonClick:) frame:CGRectZero bgColor:nil font:nil selectImage:nil selectTitle:nil selectColor:nil layout:0 button:nil];
                           
                           )
lazyloading_implementation(SDTimeLineCellOperationMenu *, commentMenu,
                           
                           _commentMenu = [SDTimeLineCellOperationMenu new];
                         
                           )

lazyloading_implementation(YYLabel *, praiseLabel,
                           
                           _praiseLabel = [UIView createYYLabel:CGRectZero bgColor:[UIColor greenColor] font:[UIFont systemFontOfSize:16] textColor:[UIColor grayColor] alignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByWordWrapping numberOfLines:0 text:@"赞美展示"];
                           )


@end
