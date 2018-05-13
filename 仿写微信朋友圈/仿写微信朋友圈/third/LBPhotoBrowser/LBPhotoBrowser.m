//
//  LBPhotoBrowser.m
//
//  Created by 刘博 on 16/5/3.
//  Copyright © 2016年 刘博. All rights reserved.
//

#import "LBPhotoBrowser.h"
#import "LBPhotoBrowserImageView.h"
#import "UIImageView+WebCache.h"

/* 屏幕宽高 */
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
/**< 图片间距 */
static CGFloat        const kMargin            = 10.0f;

/**< 动画时间 */
static CFTimeInterval const kAnimationDuration = 0.4f;

@interface LBPhotoBrowser () <UIScrollViewDelegate>

/**< 滚动视图 */
@property (nonatomic, strong) UIScrollView  *scrollView;

/**< 页码 */
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger     currentImageIndex; /**<当前图片index*/
@property (nonatomic, assign) CGRect        itemFrame;         /**<源图片imageView的frame*/
@property (nonatomic, strong) UIView        *sourceView;       /**<源图片父视图*/
@property (nonatomic, assign) NSInteger     sourceSection;     /**<源视图section，如果源视图为tableView或collectionView*/
@property (nonatomic, strong) UIView        *bottomView;
@property (nonatomic, strong) UIButton      *tempBG;
@property (nonatomic, strong) UIImageView      *tempView;

@property (nonatomic, strong) NSMutableArray      *sourceImageFrames;

@property (nonatomic, assign) BOOL     isShow;
@end

@implementation LBPhotoBrowser

#pragma mark - override

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _sourceImageFrames = @[].mutableCopy;
        [self addSubview:self.tempView];
        _isShow = NO;
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.width += kMargin * 2;/* 和图片边距有关，是第一张和最后一张图片与屏幕没有空隙 */
    
    _scrollView.bounds = rect;
    _scrollView.center = self.center;

    CGFloat y      = 0;
    CGFloat width  = _scrollView.frame.size.width - kMargin * 2;
    CGFloat height = _scrollView.frame.size.height;
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = kMargin + idx * (kMargin * 2 + width);
        obj.frame = CGRectMake(x, y, width, height);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    _scrollView.contentOffset = CGPointMake(_currentImageIndex * _scrollView.frame.size.width, 0);
    
    self.pageControl.frame = CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 20);
}

/**
 *  单击图片事件(关闭LBPhotoBrowser)
 *
 *  @param recognizer 单击手势
 */
- (void)imageSingleTap:(UITapGestureRecognizer *)recognizer {
    _isShow = NO;
    _scrollView.hidden = YES;
    if (_currentImageIndex>=_imageCount) {
        return;
    }
    CGRect rect = [_sourceImageFrames[_currentImageIndex] CGRectValue];
    BOOL flag = NO;

    LBPhotoBrowserImageView *currentImageView = (LBPhotoBrowserImageView *)recognizer.view;
    UIImageView *tempView = self.tempView;
    tempView.contentMode = _sourceView.contentMode;
    tempView.clipsToBounds = YES;
    tempView.image = currentImageView.image;
    CGFloat height = (self.bounds.size.width / currentImageView.image.size.width) * currentImageView.image.size.height;
    if (!currentImageView.image) {
        height = self.bounds.size.height;
    }
    
    tempView.bounds = CGRectMake(0, 0, self.bounds.size.width * currentImageView.totalScale, height * currentImageView.totalScale);
    tempView.center = self.center;
    
    [self addSubview:tempView];
    [self.pageControl removeFromSuperview];
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        if (flag) {
            self.alpha = 0;
        }
        else {
//            tempView.frame = CGRectMake(x, y, _itemFrame.size.width, _itemFrame.size.height);
            tempView.frame = rect;
            self.backgroundColor = [UIColor clearColor];
        }
    } completion:^(BOOL finished) {
        NSArray * array = [self.subviews copy];
        for (UIView * view in array){
            [view removeFromSuperview];
        }
        
        [self.sourceImageFrames removeAllObjects];
        _currentImageIndex = 0;
        _imageCount = 0;
        _firstSize = CGSizeZero;
        _sourceView = nil;
//        _delegate = nil;
        _itemFrame = CGRectZero;
        _scrollView = nil;
        self.alpha = 0;
        [self removeFromSuperview];
        
        [self addSubview:self.tempView];
    }];
}



#pragma mark - public method

/**
 *  展示LBPhotoBrowser
 *
 *  @param view    源视图（图片所在的imageView或button）
 *  @param index   索引（源视图为scrollView、tableView或collectionView时使用，tableView或collectionView传入indexPath.row，第一        张或单张图片传入0）
 *  @param section 源视图为tableView或collectionView时使用，传入indexPath.section，否则传入0或nil
 */
- (void)showWithView:(UIView *)view index:(NSInteger)index section:(NSInteger)section sourceImageViews:(NSArray<UIImageView *> *)sourceImageViews{ // sourceImageViews内的视图要与显示的图片的顺序相同，用于计算退出时的frame
    _isShow = YES;
    /* 本View与屏幕重合 */
    [self addToWindow];
    CGRect rect = [view.superview convertRect:view.frame toView:[[UIApplication sharedApplication] delegate].window];
//    CGRect rect1 = view.frame;
    _itemFrame         = rect;
    _currentImageIndex = index;
    _sourceView        = view;
    _sourceSection     = section;
    
        CGRect imgRect ;
        for (int i=0; i<sourceImageViews.count; i++) {
            UIView * imgV = sourceImageViews[i];
            imgRect = [imgV.superview convertRect:imgV.frame toView:[[UIApplication sharedApplication] delegate].window];
            NSValue * v = [NSValue valueWithCGRect:imgRect];
            [_sourceImageFrames addObject:v];
        }
    
    

    /*
     *  创建一个假的ImageView，用来做过渡动画
     *
     **/
    UIImageView *tempView = self.tempView;
    
    /*
     *  加载高质量的图片，低质量的图片作为占位图
     */
    if ([self highQualityImageURLForIndex:_currentImageIndex]) {
        [tempView sd_setImageWithURL:[self highQualityImageURLForIndex:_currentImageIndex]
                    placeholderImage:[self placeholderImageForIndex:_currentImageIndex]];
    }
    //    tempView.image = [self placeholderImageForIndex:index];
    
    CGFloat x = _itemFrame.origin.x;
    CGFloat y = _itemFrame.origin.y;
    /*
     *  要放大的view相对于屏幕的frame
     */
    tempView.frame = CGRectMake(x, y, _itemFrame.size.width, _itemFrame.size.height);;
    tempView.contentMode = UIViewContentModeScaleToFill;
    _scrollView.hidden = YES;
    
    CGFloat height = 0;
    height = self.bounds.size.width / _firstSize.width * _firstSize.height;
    
    
    float y1 = 0;
    if (height > self.bounds.size.height) {
        y1 = 0;
    } else {
        y1 = (self.bounds.size.height - height ) * 0.5;
    }
    [UIView animateWithDuration:kAnimationDuration animations:^{
        
        tempView.frame = CGRectMake(0, y1, SCREEN_WIDTH, height);

    } completion:^(BOOL finished) {
                [tempView removeFromSuperview];
                _scrollView.hidden = NO;
        
        self.pageControl.numberOfPages = _imageCount;
        self.pageControl.currentPage = _currentImageIndex;
        [self addSubview:self.pageControl];
        [[[UIApplication sharedApplication] delegate].window endEditing:YES];
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 1;
        [self setupImageOfImageViewForIndex:_currentImageIndex];
    }];
    
}

#pragma mark - private methods

/**
 *  添加至window
 */
- (void)addToWindow {
    self.frame = [UIApplication sharedApplication].delegate.window.bounds;
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    self.alpha = 1;

}

- (void)didMoveToSuperview {
    if (_isShow) {
        
        /*
         创建滚动视图的时候，添加单击手势， 取消
         */
        [self addSubview:self.scrollView];
        [self setupImageOfImageViewForIndex:_currentImageIndex];
        

    }

}

- (void)setupImageOfImageViewForIndex:(NSInteger)index {
    if (index >= _scrollView.subviews.count) {
        return;
    }
    LBPhotoBrowserImageView *imageView = _scrollView.subviews[index];
    self.currentImageIndex = index;
    
    if (imageView.hasLoadedImage) {
        return;
    }
 
    if ([self highQualityImageURLForIndex:index]) {
        __block UIImage * image = nil;
      
            image = [self placeholderImageForIndex:index];

            [imageView setImageWithURL:[self highQualityImageURLForIndex:index]
                      placeholderImage:image];

    }
    else {
        imageView.image = [self placeholderImageForIndex:index];
    }
    imageView.hasLoadedImage = YES;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate                       = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.pagingEnabled                  = YES;
        
        /* 遍历添加空imageView */
        for (int i = 0; i < _imageCount; i++) {
            LBPhotoBrowserImageView *imageView = [[LBPhotoBrowserImageView alloc] init];
            imageView.tag = i;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.userInteractionEnabled = YES;
            UIImage * image = [self placeholderImageForIndex:i];
            imageView.image = image;

            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSingleTap:)];
            [imageView addGestureRecognizer:singleTap];


            [_scrollView addSubview:imageView];
        }
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.enabled = NO;
    }
    return _pageControl;
}

- (UIImageView *)tempView{
    if (!_tempView) {
        _tempView = [[UIImageView alloc] init];
    }
    return _tempView;
}

- (UIViewController *)currentController {
    [UIApplication sharedApplication].delegate.window.windowLevel = UIWindowLevelAlert;
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _currentImageIndex = (scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width;
    self.pageControl.currentPage = _currentImageIndex;
    
    /*
     *  有过缩放的图片在滑出屏幕后清除缩放
     */
    for (LBPhotoBrowserImageView *imageView in scrollView.subviews) {
        if (imageView.isScaled) {
            if (scrollView.contentOffset.x <= imageView.frame.origin.x - scrollView.frame.size.width ||
                scrollView.contentOffset.x >= imageView.frame.origin.x + imageView.frame.size.width) {
                imageView.transform = CGAffineTransformIdentity;
                [imageView clearScale];
                break;
            }
        }
    }
    
    if (ABS(_currentImageIndex - (scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width) < 0.1) {
        [self setupImageOfImageViewForIndex:_currentImageIndex];
    }
    
}

/**
 *  占位图
 *
 *  @param index 索引
 */
- (UIImage *)placeholderImageForIndex:(NSInteger)index {
    if ([_delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [_delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

/**
 *  高质量
 *
 *  @param index 索引
 */
- (NSURL *)highQualityImageURLForIndex:(NSInteger)index {
    if ([_delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [_delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}


/**
 *  长按图片事件
 *
 *  @param recognizer 长按手势
 */
- (void)imageLongPress:(UILongPressGestureRecognizer *)recognizer {
    [self addSubview:self.tempBG];
    [self addSubview:self.bottomView];
    [UIView animateWithDuration:0.3 animations:^{
        self.tempBG.alpha = 0.3;
        self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 110, SCREEN_WIDTH, 110);
    }];
}

/**
 *  保存按钮点击事件（保存图片）
 *
 *  @param sender 保存按钮
 */
- (void)saveBtnClick:(UIButton *)sender {
    UIImageView *currentImageView = _scrollView.subviews[_currentImageIndex];

    UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
/*   上边调用   */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [self cancelBtnClick:nil];

    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = @"保存失败";
    }   else {
        label.text = @"保存成功";
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2.0];

}

/**
 *  取消按钮点击事件
 *
 *  @param sender   f
 */
- (void)cancelBtnClick:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.tempBG.alpha = 0;
        self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 110);
    } completion:^(BOOL finished) {
        [self.tempBG removeFromSuperview];
        [self.bottomView removeFromSuperview];
    }];
}
/*
 长按  才会添加此View
 */
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 110);
        _bottomView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        saveBtn.backgroundColor = [UIColor whiteColor];
        saveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [saveBtn setTitle:@"保存图片" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:saveBtn];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 60, SCREEN_WIDTH, 50);
        cancelBtn.backgroundColor = [UIColor whiteColor];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:cancelBtn];
    }
    return _bottomView;
}

@end
