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
@property (nonatomic, copy) SGHomeViewCellActionBlock actionBlock;
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

    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(press:)];
    press.minimumPressDuration = 0.5f;
    [self.contentView addGestureRecognizer:press];
}
-(void)setAlbum:(SGPhotoModel *)album
{
     NSURL *url = album.thumbURL;
    self.backgroundImageView.image = [UIImage imageWithContentsOfFile:url.path];;
}
- (void)press:(UILongPressGestureRecognizer *)ges {
    if (ges.state != UIGestureRecognizerStateBegan) return;
        if (self.actionBlock) {
            self.actionBlock();
        }
    
}
- (void)setAction:(SGHomeViewCellActionBlock)actionBlock {
    _actionBlock = actionBlock;
}
@end
