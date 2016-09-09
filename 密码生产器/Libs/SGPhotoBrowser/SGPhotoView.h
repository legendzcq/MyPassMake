//
//  SGPhotoView.h
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGZoomingImageView.h"

@class SGPhotoModel;
@class SGPhotoBrowser;
@class SGPhotoViewController;

#define PhotoGutt 20

typedef void(^SGPhotoViewTapHandlerBlcok)(void);
typedef void(^getcurrentPhotoBlock)(SGPhotoModel *currentPhoto);
@interface SGPhotoView : UIScrollView

@property (nonatomic, weak) SGPhotoViewController *controller;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) SGZoomingImageView *currentImageView;

- (void)setSingleTapHandlerBlock:(SGPhotoViewTapHandlerBlcok)handler;
- (void)layoutImageViews;
-(SGPhotoModel *)getcurrentPhoto;
@end
