//
//  LBPhotoBrowserImageView.m
//
//  Created by 刘博 on 16/5/4.
//  Copyright © 2016年 刘博. All rights reserved.
//

#import "LBPhotoBrowserImageView.h"
#import "LBWaitingView.h"
#import "UIImageView+WebCache.h"
#define LB_BACKGROUND_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]

@interface LBPhotoBrowserImageView ()

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIImageView   *zoomImageView;

@property (nonatomic, strong) LBWaitingView *waitingView;
@property (nonatomic, assign) CGFloat minScale;//最小比例
/**
 *  缩放过程中
 *  总的缩放比例为1时
 *  的偏移量
 */
@property (nonatomic, assign) CGFloat zoomScale_1_scrollOffsetY;
/**
 *  图片宽度为屏幕宽度时 的 图片高度
 *
 *  也就是图片的最开始的高度
 */
@property (nonatomic, assign) CGFloat zoomImgOriginalHeight;
@property (nonatomic, assign) CGFloat progress;
@end

@implementation LBPhotoBrowserImageView

#pragma mark - override

- (id)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        _totalScale = 1.0;
   
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(imagePinch:)];
        [self addGestureRecognizer:pinch];
    }
    return self;
}

#pragma mark - event respons

- (void)imagePinch:(UIPinchGestureRecognizer *)recognizer {
    
    CGFloat scale = 0.0;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if(_totalScale<1){
            scale = 1/_totalScale;
        }else{
            return;
        }
    }else{
            scale = recognizer.scale;
        
            if (_totalScale <= 1&&self.zoomScale_1_scrollOffsetY == -1) {
                self.zoomScale_1_scrollOffsetY = self.scrollView.contentOffset.y;
            }
    }
    CGFloat temp = _totalScale * scale;
    [self setTotalScale:temp scale:scale state:(UIGestureRecognizerState)recognizer.state];
    recognizer.scale = 1.0; /* 默认在 */
}


#pragma mark - private method

- (void)clearScale {
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
    self.zoomImageView = nil;
//    _totalScale = 1.0;
}

#pragma mark - setters

- (void)setTotalScale:(CGFloat)totalScale scale:(CGFloat)scale state:(UIGestureRecognizerState)state{
    if ((totalScale <= _minScale) ||
        (totalScale >= 2.0))
        return;
    
    [self zoomWithScale:totalScale scale:(CGFloat)scale state:(UIGestureRecognizerState)state];
}

- (void)zoomWithScale:(CGFloat)totalScale scale:(CGFloat)scale state:(UIGestureRecognizerState)state{
    
    _totalScale = totalScale;
    
    self.zoomImageView.transform = CGAffineTransformMakeScale(totalScale, totalScale);
    

    
    CGFloat contentW = self.zoomImageView.frame.size.width;
    CGFloat contentH = MAX(self.zoomImageView.frame.size.height, self.frame.size.height);
    
    if (_totalScale > 1) {

        self.zoomImageView.frame = CGRectMake(0, 0, contentW, contentH);
        self.scrollView.contentSize = CGSizeMake(contentW, contentH);
    } else {

        self.zoomImageView.frame = CGRectMake((self.scrollView.frame.size.width-contentW)/2.0, 0, contentW, contentH);
        self.scrollView.contentSize = CGSizeMake( self.scrollView.frame.size.width, contentH);
        if (_zoomImgOriginalHeight == self.bounds.size.height) {
                self.zoomImageView.frame = CGRectMake((self.scrollView.frame.size.width-contentW)/2.0, 0, contentW, _zoomImgOriginalHeight);
                self.scrollView.contentSize = CGSizeMake( self.scrollView.frame.size.width, _zoomImgOriginalHeight);
            
            
        }else{
            self.zoomImageView.frame = CGRectMake((self.scrollView.frame.size.width-contentW)/2.0, 0, contentW, contentH);
            self.scrollView.contentSize = CGSizeMake( self.scrollView.frame.size.width, contentH);
        }
        
    }

    CGFloat offset_x = (MAX(contentW, self.scrollView.frame.size.width) - self.scrollView.frame.size.width)/2.0;
    

    CGFloat offset_y = self.scrollView.contentOffset.y * scale + self.frame.size.height * (scale - 1)/2.0;
    offset_y = offset_y>0 ? offset_y :0;
    
    if (state == UIGestureRecognizerStateEnded&&_totalScale<=1&&self.zoomScale_1_scrollOffsetY!=-1) {
        offset_y = self.zoomScale_1_scrollOffsetY;
    }
    
    CGPoint offset = CGPointMake(offset_x, offset_y);
    self.scrollView.contentOffset = offset;
    
    if (state == UIGestureRecognizerStateEnded) {
        self.zoomScale_1_scrollOffsetY = -1;
    }

}



#pragma mark - getters

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.contentSize = self.bounds.size;
        [_scrollView addSubview:self.zoomImageView];
        

        self.zoomImageView.image = self.image;
    }
    return _scrollView;
}


- (UIImageView *)zoomImageView {
    if (!_zoomImageView) {
        _zoomImageView = [[UIImageView alloc] initWithImage:self.image];
        CGSize imageSize = _zoomImageView.image.size;
        CGFloat imageViewH = self.bounds.size.height;
        if (imageSize.width > 0) {
            imageViewH = self.bounds.size.width * (imageSize.height / imageSize.width);
        }
        _zoomImageView.bounds = CGRectMake(0, 0, self.bounds.size.width, imageViewH);
        _zoomImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _zoomImageView;
}


- (BOOL)isScaled {
    return 1.0 != _totalScale;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _waitingView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    
    if (![self.scrollView isDescendantOfView:self]) {
        [self addSubview:self.scrollView];
        if (_waitingView) {
            [self bringSubviewToFront:_waitingView];
        }
    }
    
    CGSize imageSize = self.image.size;
    
    _scrollView.frame = self.bounds;
    
    if (imageSize.width == 0) {
        if (!self.image) {
            NSLog(@"图片不存在");
        }
        return;
    }
    CGFloat imageViewH = MAX(self.bounds.size.width * (imageSize.height / imageSize.width), self.bounds.size.height) ;
    _zoomImgOriginalHeight = imageViewH;
    _minScale = self.bounds.size.height*(imageSize.width / imageSize.height)/self.bounds.size.width;
    if (_minScale >= 1) {
        _minScale = 0.5;
    }
    
    _zoomImageView.bounds = CGRectMake(0, 0, _scrollView.frame.size.width, imageViewH);
    
    /*
     *  如果图片的高度与滚动视图完全重合，图片居上显示
     */
    _zoomImageView.center = CGPointMake(_scrollView.frame.size.width * 0.5, _zoomImageView.frame.size.height * 0.5);
    
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _zoomImageView.bounds.size.height);
    
}


- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    LBWaitingView *waiting = [[LBWaitingView alloc] init];
    waiting.bounds = CGRectMake(0, 0, 100, 100);
    waiting.progress = 0;
    waiting.mode = LBWaitingViewModeLoopDiagram;
    _waitingView = waiting;
    _waitingView.hidden = YES;
    [self addSubview:waiting];
    
    
    __weak LBPhotoBrowserImageView *imageViewWeak = self;
    __block float lastRate = 0;

    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        float rate = (CGFloat)receivedSize / expectedSize;
        if (rate-lastRate >= 0.1 && rate <= 0.95) {
            lastRate = rate;
            _waitingView.hidden = NO;
            imageViewWeak.progress = (CGFloat)rate;
        }

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_waitingView removeFromSuperview];


        if (error) {
            _zoomImageView.image = placeholder;
            [_zoomImageView setNeedsDisplay];

            UILabel *label = [[UILabel alloc] init];
            label.bounds = CGRectMake(0, 0, 160, 30);
            label.center = CGPointMake(imageViewWeak.bounds.size.width * 0.5, imageViewWeak.bounds.size.height * 0.5);
            label.text = @"图片加载失败";
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
            label.layer.cornerRadius = 5;
            label.clipsToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            [imageViewWeak addSubview:label];
        } else {
            _zoomImageView.image = image;
            [_zoomImageView setNeedsDisplay];
        }

    }];
}
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    _waitingView.progress = progress;
    
}
@end
