//
//  LBPhotoBrowser.h
//
//  Created by 刘博 on 16/5/3.
//  Copyright © 2016年 刘博. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBPhotoBrowserDelegate;

@interface LBPhotoBrowser : UIView

@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic, assign) CGSize firstSize;

/**< 代理 */
@property (nonatomic, weak, nullable) id<LBPhotoBrowserDelegate> delegate;

/**
 *  展示LBPhotoBrowser
 *
 *  @param view    源视图（图片所在的imageView或button）
 *  @param index   索引（源视图为scrollView、tableView或collectionView时使用，tableView或collectionView传入indexPath.row，第一        张或单张图片传入0）
 *  @param section 源视图为tableView或collectionView时使用，传入indexPath.section，否则传入0或nil
 */
- (void)showWithView:(nonnull UIView *)view index:(NSInteger)index section:(NSInteger)section sourceImageViews:(NSArray<UIImageView *> *_Nullable)sourceImageViews;//sourceImageViews 是我自己添加的

@end

@protocol LBPhotoBrowserDelegate <NSObject>

@required


/**
 *  占位图
 *
 *  @param browser e
 *  @param index e
 *
 *  @return e
 */
- (nonnull UIImage *)photoBrowser:(nonnull LBPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

/**
 *  高清图
 *
 *  @param browser e
 *  @param index e
 *
 *  @return e
 */
- (nonnull NSURL *)photoBrowser:(nonnull LBPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end
