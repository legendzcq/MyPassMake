//
//  SGPhotoViewController.h
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGPhotoModel;
@class JMBLoginController;

@interface LGPhotoViewController : UIViewController

@property (nonatomic, weak) JMBLoginController *browser;
@property (nonatomic, assign) NSInteger index;

@end
