//
//  SGBrowserToolBar.h
//  SGSecurityAlbum
//
//  Created by soulghost on 13/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGBlockToolBar.h"
#import "LGBrowserMainToolBar.h"
#import "LGBrowserSecondToolBar.h"

@class LGBrowserMainToolBar;
@class LGBrowserSecondToolBar;

#define SGBrowserToolButtonEdit -1
#define SGBrowserToolButtonBack -2
#define SGBrowserToolButtonAction -3
#define SGBrowserToolButtonTrash -4

@interface LGBrowserToolBar : UIView

@property (nonatomic, weak) LGBrowserMainToolBar *mainToolBar;
@property (nonatomic, weak) LGBrowserSecondToolBar *secondToolBar;
@property (nonatomic, assign) BOOL isEditing;

@end
