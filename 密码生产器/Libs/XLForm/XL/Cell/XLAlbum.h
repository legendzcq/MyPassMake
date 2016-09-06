//
//  XLAlbum.h
//  密码生产器
//
//  Created by 张传奇 on 16/9/6.
//  Copyright © 2016年 张传奇. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_OPTIONS(NSInteger, SGAlbumType) {
    SGAlbumButtonTypeCommon = 0,
    SGAlbumButtonTypeAddButton
};
@interface XLAlbum : NSObject
@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *coverImageURL;
@property (nonatomic, assign) SGAlbumType type;
@end
