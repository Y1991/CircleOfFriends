//
//  YGQ_FriendCircleImageDisplayNew.m
//  仿写微信朋友圈
//
//  Created by Guangquan Yu on 2017/11/16.
//  Copyright © 2017年 ZHM.YU. All rights reserved.
//

#import "YGQ_FriendCircleImageDisplayNew.h"
@interface YGQ_FriendCircleImageDisplayNew ()<LBPhotoBrowserDelegate>
@property (nonatomic, strong) LBPhotoBrowser             *photoBrowser;

@property(nonatomic,strong)NSMutableArray<ZZJijinModel *> * dataArr;

@property(nonatomic,strong)NSMutableArray<UIImageView *> * imgViewArr;
@property(nonatomic,strong)NSMutableArray<UIImage *> * imgArr;
@end
@implementation YGQ_FriendCircleImageDisplayNew
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
        _imgViewArr = [NSMutableArray arrayWithCapacity:0];
        _imgArr = [NSMutableArray arrayWithCapacity:0];
        
        for (int i=0; i<9; i++) {
            UIImageView * imageView = [UIView makeImageView:CGRectZero imageName:nil];
            imageView.tag = i;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [self addSubview:imageView];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            [imageView addGestureRecognizer:tap];
            [_imgViewArr addObject:imageView];
 
            _photoBrowser = [[LBPhotoBrowser alloc] init];
            _photoBrowser.delegate = self;
        }
    }
    return self;
}

-(void)setCountDic:(NSDictionary *)countDic{
    _countDic = countDic;
    NSInteger count = [countDic[@"count"] integerValue];
    if (_dataArr.count) {
        [_dataArr removeAllObjects];
    }
    if (_imgArr.count) {
        [_imgArr removeAllObjects];
    }
    
    for (int i=0; i<_imgViewArr.count; i++) {
        UIImageView * imageV = _imgViewArr[i];
        imageV.hidden = YES;
    }
    [_dataArr addObjectsFromArray:countDic[@"dataArr"]];
    
    CGSize collectionSize = [countDic[@"collectionSize"] CGSizeValue];
    CGFloat collectionWidth = 0;
    CGFloat collectionHeight = 0;
    collectionWidth = collectionSize.width;
    collectionHeight = collectionSize.height;
    int widthCount = (collectionWidth)/(80+3);
    
    if (count == 1) {
        CGFloat cWidth = 0;
        CGFloat cHeight = 0;
        CGFloat oneWidth = 100;
        CGFloat oneHeight = 200;
        if (oneWidth > oneHeight) {
            cWidth = (80+3)*2+3;
            cHeight = cWidth*(oneHeight/oneWidth);
        } else {
            cHeight = (80+3)*2+3;
            cWidth = cHeight*(oneWidth/oneHeight);
        }
        oneWidth = cWidth-6;
        oneHeight = cHeight-6;
        
        UIImageView * imageV = _imgViewArr[0];
        imageV.hidden = NO;
        imageV.frame = CGRectMake(3, 3, oneWidth, oneHeight);
        
        UIImage * image = [UIImage imageNamed:_dataArr[0].stateImageName];
        if (image) {
            imageV.image = image;
            [_imgArr addObject:image];
        }
    }else{
        for (int i=0; i<_dataArr.count; i++) {
            UIImageView * imageV = _imgViewArr[i];
            imageV.hidden = NO;
            
            CGFloat x = 3+(80+3)*(i%widthCount);
            CGFloat y = 3+(80+3)*(i/widthCount);
            
            imageV.frame = CGRectMake(x, y, 80, 80);
            
            UIImage * image = [UIImage imageNamed:_dataArr[i].stateImageName];
            if (image) {
                imageV.image = image;
                [_imgArr addObject:image];
            }
        }
    }

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

- (void)tapClick:(UITapGestureRecognizer *)tap{
    UIImageView * imageV = (UIImageView * )tap.view;
    NSInteger index = imageV.tag;

        _photoBrowser.imageCount = _dataArr.count;
    
        ZZJijinModel *imageModel = _dataArr[index];
        _photoBrowser.firstSize = imageModel.imageSize;
    
        [_photoBrowser showWithView:imageV
                              index:index
                            section:0
         sourceImageViews:[_imgViewArr subarrayWithRange:NSMakeRange(0, _dataArr.count)]];
    
}

- (nonnull UIImage *)photoBrowser:(nonnull LBPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {

    return [UIImage imageNamed:@"praise_select.png"];
}

- (nonnull NSURL *)photoBrowser:(nonnull LBPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {

    ZZJijinModel *imageModel = _dataArr[index];
    return [NSURL URLWithString:imageModel.stateImageUrl];
}

@end
