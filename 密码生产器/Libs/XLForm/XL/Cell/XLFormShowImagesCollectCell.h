//
//  XLFormShowImagesCollectCell.h
//  密码生产器
//
//  Created by 张传奇 on 16/9/6.
//  Copyright © 2016年 张传奇. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SGHomeViewCellActionBlock)(void);
@class SGPhotoModel;
@interface XLFormShowImagesCollectCell : UICollectionViewCell
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, strong) LGPhotoModel *album;
- (void)setAction:(SGHomeViewCellActionBlock)actionBlock;
@end
