//
//  XLFormShowImagesCollectCell.m
//  密码生产器
//
//  Created by 张传奇 on 16/9/6.
//  Copyright © 2016年 张传奇. All rights reserved.
//

#import "XLFormShowImagesCollectCell.h"
#import "Masonry.h"
#import "SGPhotoModel.h"
@interface XLFormShowImagesCollectCell ()

@property (nonatomic, weak) UIImageView *backgroundImageView;

@end
@implementation XLFormShowImagesCollectCell
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"SGHomeViewCell";
    [collectionView registerClass:[XLFormShowImagesCollectCell class] forCellWithReuseIdentifier:ID];
    XLFormShowImagesCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    return cell;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    UIImageView *backgroundImageView = [UIImageView new];

    [self.contentView addSubview:backgroundImageView];
    self.backgroundImageView = backgroundImageView;
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
//    UIImageView *thumbImageView = [UIImageView new];
//    [self.contentView addSubview:thumbImageView];
//    self.thumbImageView = thumbImageView;
//    UILabel *nameLabel = [UILabel new];
//    nameLabel.text = @"Default";
//    nameLabel.textAlignment = NSTextAlignmentCenter;
//    [self.contentView addSubview:nameLabel];
//    self.nameLabel = nameLabel;
//    [thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.backgroundImageView.mas_top).offset(15);
//        self.thumbLeftConstraint = make.left.equalTo(self.backgroundImageView.mas_left).offset(20);
//        self.thumbRightConstraint = make.right.equalTo(self.backgroundImageView.mas_right).offset(-20);
//        make.bottom.equalTo(self.nameLabel.mas_top).offset(0);
//    }];
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.equalTo(0);
//        make.bottom.equalTo(self.backgroundImageView.mas_bottom).offset(-8);
//    }];
//    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(press:)];
//    press.minimumPressDuration = 0.5f;
//    [self.contentView addGestureRecognizer:press];
}
-(void)setAlbum:(SGPhotoModel *)album
{
     NSURL *url = album.thumbURL;
    self.backgroundImageView.image = [UIImage imageWithContentsOfFile:url.path];;
}
@end
