//
//  UIImageView+SGExtension.h
//  SGSecurityAlbum
//
//  Created by soulghost on 14/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGPhotoModel;

@interface UIImageView (SGExtension)

@property (nonatomic, weak) MBProgressHUD *hud;
@property (nonatomic, strong) LGPhotoModel *model;


- (void)sg_setImageWithURL:(NSURL *)url;
- (void)sg_setImageWithURL:(NSURL *)url model:(LGPhotoModel *)model;

@end
