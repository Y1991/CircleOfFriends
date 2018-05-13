//
//  YGQ_FriendCircleImageDisplay.m
//  仿写微信朋友圈
//
//  Created by Guangquan Yu on 2017/11/14.
//  Copyright © 2017年 ZHM.YU. All rights reserved.
//

#import "YGQ_FriendCircleImageDisplay.h"
#import "ImageDisplayCollectionViewCell.h"
@interface YGQ_FriendCircleImageDisplay ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LBPhotoBrowserDelegate>
/* 大图查看器 */
@property (nonatomic, strong) LBPhotoBrowser             *photoBrowser;

@property(nonatomic,strong)NSMutableArray<ZZJijinModel *> * dataArr;

@property(nonatomic, assign)CGFloat oneWidth;
@property(nonatomic, assign)CGFloat oneHeight;
@end
@implementation YGQ_FriendCircleImageDisplay
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
        
        [self makeCollectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.width.equalTo(self);
            make.height.equalTo(self);
        }];
        
    }
    return self;
}

-(void)setCountDic:(NSDictionary *)countDic{
    _countDic = countDic;
    NSInteger count = [countDic[@"count"] integerValue];
    if (_dataArr) {
        [_dataArr removeAllObjects];
    }
    [_dataArr addObjectsFromArray:countDic[@"dataArr"]];
    CGSize collectionSize = [countDic[@"collectionSize"] CGSizeValue];

    if (count == 1) {
        CGFloat cWidth = 0;
        CGFloat cHeight = 0;
        _oneWidth = 100;
        _oneHeight = 200;
        if (_oneWidth > _oneHeight) {
            cWidth = (80+3)*2+3;
            cHeight = cWidth*(_oneHeight/_oneWidth);
        } else {
            cHeight = (80+3)*2+3;
            cWidth = cHeight*(_oneWidth/_oneHeight);
        }
        _oneWidth = cWidth-6;
        _oneHeight = cHeight-6;
        
    }

    CGFloat collectionWidth = 0;
    CGFloat collectionHeight = 0;
    collectionWidth = collectionSize.width;
    collectionHeight = collectionSize.height;

    [self.collectionView reloadData];
}

+ (CGSize)getCollectionSizeWithCount:(NSInteger)count{
    CGFloat collectionWidth = 0;
    CGFloat collectionHeight = 0;
    
    if (count == 1) {
        CGFloat oneWidth = 100;
        CGFloat oneHeight = 200;
        if (oneWidth > oneHeight) {
            collectionWidth = (80+3)*2+3;
            collectionHeight = collectionWidth*(oneHeight/oneWidth);
        } else {
            collectionHeight = (80+3)*2+3;
            collectionWidth = collectionHeight*(oneWidth/oneHeight);
        }
        
        
    } else if (count == 2) {
        collectionWidth = (80+3)*2+3;
        collectionHeight = 80+3+3;
        
    } else if (count == 3) {
        collectionWidth = (80+3)*3+3;
        collectionHeight = 80+3+3;
        
    } else if (count == 4) {
        collectionWidth = (80+3)*2+3;
        collectionHeight = (80+3)*2+3;
        
    } else if (count == 5) {
        collectionWidth = (80+3)*3+3;
        collectionHeight = (80+3)*2+3;
        
    } else if (count == 6) {
        collectionWidth = (80+3)*3+3;
        collectionHeight = (80+3)*2+3;
    }
    
    return CGSizeMake(collectionWidth, collectionHeight);
}

- (void)makeCollectionView{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    [_collectionView setBackgroundColor:[UIColor whiteColor]];

    [self.collectionView registerClass:[ImageDisplayCollectionViewCell class] forCellWithReuseIdentifier:@"ImageDisplayCollectionViewCell"];
    [self addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];

}

#pragma mark - UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    ImageDisplayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageDisplayCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
       
    }
    if (_dataArr.count) {
        cell.model = _dataArr[indexPath.row];
    }else{
        
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArr.count == 1) {
        return CGSizeMake(_oneWidth, _oneHeight);
    }
    return CGSizeMake(80, 80);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsMake(3, 3, 3, 3);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    
    
    return 3;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 3;
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return nil;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _photoBrowser = [[LBPhotoBrowser alloc] init];
    _photoBrowser.delegate = self;
    _photoBrowser.imageCount = _dataArr.count;
    
    ImageDisplayCollectionViewCell *cell = (ImageDisplayCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ZZJijinModel *imageModel = _dataArr[indexPath.row];
    _photoBrowser.firstSize = imageModel.imageSize;

    [_photoBrowser showWithView:cell.imageView1
                          index:indexPath.row
                        section:indexPath.section sourceImageViews:nil];

}


#pragma mark - LBPhotoBrowserDelegate

- (nonnull UIImage *)photoBrowser:(nonnull LBPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    UIImage * image = nil;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    ImageDisplayCollectionViewCell *cell = (ImageDisplayCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    image = [UIImage imageWithData:UIImageJPEGRepresentation(cell.imageView1.image, 1.0f) scale:0.5f];
    
    
    return image;
    //    return self.imageV.image;
}

- (nonnull NSURL *)photoBrowser:(nonnull LBPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    ZZJijinModel *imageModel = _dataArr[indexPath.row];
    return [NSURL URLWithString:imageModel.stateImageUrl];

}

@end
