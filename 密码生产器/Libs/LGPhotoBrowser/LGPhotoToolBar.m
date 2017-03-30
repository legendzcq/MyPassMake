//
//  SGPhotoToolBar.m
//  SGSecurityAlbum
//
//  Created by soulghost on 12/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "LGPhotoToolBar.h"

@interface LGPhotoToolBar ()

@end

@implementation LGPhotoToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.translucent = YES;
        [self setupViews];
    }
    return self;
}

- (UIBarButtonItem *)createBarButtomItemWithSystemItem:(UIBarButtonSystemItem)systemItem {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:@selector(btnClick:)];
}

- (void)setupViews {
    UIBarButtonItem *trashItem = [self createBarButtomItemWithSystemItem:UIBarButtonSystemItemTrash];
    trashItem.tag = LGPhotoToolBarTrashTag;
    UIBarButtonItem *exportItem = [self createBarButtomItemWithSystemItem:UIBarButtonSystemItemAction];
    exportItem.tag = LGPhotoToolBarExportTag;
    UIBarButtonItem *spring = [self createBarButtomItemWithSystemItem:UIBarButtonSystemItemFlexibleSpace];
    self.items = @[trashItem, spring, exportItem];
}

@end
