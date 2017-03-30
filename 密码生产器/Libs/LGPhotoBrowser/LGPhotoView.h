//
//  SGPhotoView.h
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGZoomingImageView.h"

@class LGPhotoModel;
@class LGPhotoBrowser;
@class LGPhotoViewController;

#define PhotoGutt 20

typedef void(^SGPhotoViewTapHandlerBlcok)(void);
typedef void(^getcurrentPhotoBlock)(LGPhotoModel *currentPhoto);
@interface LGPhotoView : UIScrollView

@property (nonatomic, weak) LGPhotoViewController *controller;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) LGZoomingImageView *currentImageView;

- (void)setSingleTapHandlerBlock:(SGPhotoViewTapHandlerBlcok)handler;
- (void)layoutImageViews;
-(LGPhotoModel *)getcurrentPhoto;
@end
