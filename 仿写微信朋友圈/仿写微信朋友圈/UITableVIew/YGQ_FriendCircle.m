//
//  YGQ_FriendCircle.m
//  仿写微信朋友圈
//
//  Created by Guangquan Yu on 2017/11/13.
//  Copyright © 2017年 ZHM.YU. All rights reserved.
//

#import "YGQ_FriendCircle.h"
//#import "UITableView+FDTemplateLayoutCell.h"
#import "YGQ_STInputBarView.h"

@interface YGQ_FriendCircle ()<UITableViewDataSource,UITableViewDelegate,YGQ_FC_TableViewCellDelegate,YGQ_FC_CommitTableViewCellDelegate>

@property (nonatomic, strong)YGQ_STInputBarView * inputBar;

@strong_pro UITableView * tableView;

@end
@implementation YGQ_FriendCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefault];
    }
    return self;
}

- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self.tableView reloadData];
}

-(void) initDefault{
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    [self addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right. mas_equalTo(0);
    }];
    _inputBar = [YGQ_STInputBarView new];
}

-(UITableView *) tableView{
    if (!_tableView) {
        _tableView = [UIView makeTableViewWithFrame:CGRectZero style:UITableViewStyleGrouped bgColor:[UIColor whiteColor] Delegate:self registerClasses:@[@"YGQ_FC_TableViewCell",@"YGQ_FC_CommitTableViewCell"] cellReuseIdentifiers:@[@"YGQ_FC_TableViewCell",@"YGQ_FC_CommitTableViewCell"]];
    }
    return _tableView;
}

-(void)tableViewCell:(YGQ_FC_TableViewCell *)cell clickSpeakMoreButton:(BOOL)isOpen indexPath:(NSIndexPath * _Nullable)indexPath{
    NSDictionary * dic = _dataArr[indexPath.section];
    NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    BOOL isOpen_old = [dic[@"speakcontentLabel"][@"isOpening"] boolValue];
    if (isOpen_old != isOpen) {
        NSMutableDictionary * muDic11 = [NSMutableDictionary dictionaryWithDictionary:muDic[@"speakcontentLabel"]];
        muDic11[@"isOpening"] = [NSNumber numberWithBool:isOpen];
        muDic[@"speakcontentLabel"] = muDic11;
        [_dataArr replaceObjectAtIndex:indexPath.section withObject:muDic];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableViewCell:(YGQ_FC_TableViewCell *_Nullable)cell clickCommentButtonWithIndexPath:(NSIndexPath *_Nullable)indexPath{
    __weak typeof(self) weakSelf = self;
    [_inputBar addToWindowWithScrollView:self.tableView relativeView:cell kbScrollInsetBlock:^(UIEdgeInsets insets) {
        weakSelf.tableView.contentInset = insets;
    } kbScrollOffsetBlock:^(CGPoint point) {
        weakSelf.tableView.contentOffset = point;
    } updateMessageBlock:^(NSString *message, NSString *placeHolder) {
        NSDictionary * dic = weakSelf.dataArr[indexPath.section];
        NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSMutableArray * mu_plArr = [NSMutableArray arrayWithArray:dic[@"commentsContent"]];
        NSString * pl_AllHeight = dic[@"commentsH"];
        
        NSArray * data = @[
                           @{YGQCOMMENTMAN:@"Me",YGQCONTENT:[NSString stringWithFormat:@"：%@",message]}
                           ];
            NSMutableArray * dataMutable = @[].mutableCopy;
            CGFloat cellAllHeight = 0;
            for (int i=0; i<data.count; i++) {
                NSDictionary * dic = data[i];
                NSDictionary * heightDic = [YGQ_FC_CommitTableViewCell calculateHeight:dic maxWidth:([UIScreen mainScreen].bounds.size.width-60-20-20)];
                
                NSMutableDictionary * dic1 = dic.mutableCopy;
                [dic1 addEntriesFromDictionary:heightDic];
                [dataMutable addObject:dic1];
                cellAllHeight += [heightDic[@"height"] doubleValue];
            }
        [mu_plArr addObjectsFromArray:dataMutable];
        muDic[@"commentsContent"] = mu_plArr;
        muDic[@"commentsH"] = [NSString stringWithFormat:@"%f",pl_AllHeight.floatValue +cellAllHeight];
        [weakSelf.dataArr replaceObjectAtIndex:indexPath.section withObject:muDic];
        [weakSelf.tableView reloadData];
    } placeHolder:@"开始评论。。。"];
}

- (void)tableViewCell:(YGQ_FC_TableViewCell *_Nullable)cell clickPraiseButtonWithIndexPath:(NSIndexPath *_Nullable)indexPath{
    
}

- (void)tableViewCell:(YGQ_FC_CommitTableViewCell *_Nullable)cell clickCommentPeronWithName:(NSString *_Nullable)name indexPath:(NSIndexPath *_Nullable)indexPath {
    
}

#pragma mark - UITableView 代理方法
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CGFloat height = 0;
    NSString * pinglunHeight = _dataArr[section][@"commentsH"];
    height += [pinglunHeight doubleValue];
    if (height>0) {
        return 1+[_dataArr[section][@"commentsContent"] count];
    }
        return 1;
}

#pragma mark view
-(nullable UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

-(nullable UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * tableCell = nil;
    
    if (indexPath.row == 0) {
        YGQ_FC_TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YGQ_FC_TableViewCell"];
        [self configureCell:cell atIndexPath:indexPath];
        tableCell = cell;
    } else {
        YGQ_FC_CommitTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YGQ_FC_CommitTableViewCell"];
        [self configurePingLunCell:cell atIndexPath:indexPath];
        tableCell = cell;
    }
    tableCell.selectionStyle = 0;
    if ([tableCell respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableCell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([tableCell respondsToSelector:@selector(setSeparatorInset:)]){
        [tableCell setSeparatorInset:UIEdgeInsetsZero];
    }
    return tableCell;
}

#pragma mark height
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (indexPath.row == 0) {
        NSDictionary * dic = _dataArr[indexPath.section];
        if ([dic[@"speakcontentLabel"][@"isShowMoreButton"] boolValue]) {
            if ([dic[@"speakcontentLabel"][@"isOpening"] boolValue]) {
                height = [_dataArr[indexPath.section][@"limitCellOneHeight_Open"] doubleValue];
            } else {
                height = [_dataArr[indexPath.section][@"limitCellOneHeight_NoOpen"] doubleValue];
            }
        } else {
            height = [_dataArr[indexPath.section][@"cellOneHeight"] doubleValue];
        }
        
    } else {
        height = [_dataArr[indexPath.section][@"commentsContent"][indexPath.row-1][@"height"] doubleValue];
    }
    if (height <= 0) {

    }
    return height;
}

-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(7_0){
    CGFloat height = 0;
    if (indexPath.row == 0) {
        height = [_dataArr[indexPath.section][@"cellOneHeight"] doubleValue];
    } else {
        height = [_dataArr[indexPath.section][@"commentsContent"][indexPath.row-1][@"height"] doubleValue];
    }
    return height;
}

-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0){
    if (@available(iOS 11.0, *)) {
        return 0.0000001;
    }
    return 1.1;
}
-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0){
    if (@available(iOS 11.0, *)) {
        return 0.0000001;
    }
    return 1.1;
}

#pragma mark action
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
      
    } else {
        NSString * commentMan = _dataArr[indexPath.section][@"commentsContent"][indexPath.row-1][@"commentMan"];
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        __weak typeof(self) weakSelf = self;
        [_inputBar addToWindowWithScrollView:self.tableView relativeView:cell kbScrollInsetBlock:^(UIEdgeInsets insets) {
            weakSelf.tableView.contentInset = insets;
        } kbScrollOffsetBlock:^(CGPoint point) {
            weakSelf.tableView.contentOffset = point;
        } updateMessageBlock:^(NSString *message, NSString *placeHolder) {
            NSLog(@"发送消息 ===> %@   %@", placeHolder, message);
            NSDictionary * dic = weakSelf.dataArr[indexPath.section];
            NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            NSMutableArray * mu_plArr = [NSMutableArray arrayWithArray:dic[@"commentsContent"]];
            NSString * pl_AllHeight = dic[@"commentsH"];
            NSArray * data = @[
                               @{YGQCOMMENTMAN:@"Me",YGQREVERT:@"回复",YGQBYCOMMENTMAN:commentMan,YGQCONTENT:[NSString stringWithFormat:@"：%@",message]}
                               ];
            NSMutableArray * dataMutable = @[].mutableCopy;
            CGFloat cellAllHeight = 0;
            for (int i=0; i<data.count; i++) {
                NSDictionary * dic = data[i];
                NSDictionary * heightDic = [YGQ_FC_CommitTableViewCell calculateHeight:dic maxWidth:([UIScreen mainScreen].bounds.size.width-60-20-20)];
                NSMutableDictionary * dic1 = dic.mutableCopy;
                [dic1 addEntriesFromDictionary:heightDic];
                [dataMutable addObject:dic1];
                cellAllHeight += [heightDic[@"height"] doubleValue];
            }
            [mu_plArr addObjectsFromArray:dataMutable];
            muDic[@"commentsContent"] = mu_plArr;
            muDic[@"commentsH"] = [NSString stringWithFormat:@"%f",pl_AllHeight.floatValue +cellAllHeight];
            [weakSelf.dataArr replaceObjectAtIndex:indexPath.section withObject:muDic];
            [weakSelf.tableView reloadData];
        } placeHolder:[NSString stringWithFormat:@"回复:%@",commentMan]];
    }
}

- (void)configureCell:(YGQ_FC_TableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.indexPath = indexPath;
    cell.delegate = self;
    [cell loadData:_dataArr[indexPath.section]];
}

- (void)configurePingLunCell:(YGQ_FC_CommitTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.dic = _dataArr[indexPath.section][@"commentsContent"][indexPath.row-1];
}

@end
