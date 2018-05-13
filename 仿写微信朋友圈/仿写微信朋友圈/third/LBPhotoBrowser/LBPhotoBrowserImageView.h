//
//  LBPhotoBrowserImageView.h
//
//  Created by 刘博 on 16/5/4.
//  Copyright © 2016年 刘博. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBPhotoBrowserImageView : UIImageView

@property (nonatomic, assign, readonly) BOOL isScaled;

@property (nonatomic, assign) CGFloat      totalScale;

@property (nonatomic, assign) BOOL hasLoadedImage;



- (void)clearScale;


- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder ;
@end
