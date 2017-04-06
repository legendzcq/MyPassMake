//
//  XLFormShowImagesCell.m
//  密码生产器
//
//  Created by 张传奇 on 16/9/6.
//  Copyright © 2016年 张传奇. All rights reserved.
//

#import "XLFormShowImagesCell.h"
#import "XLFormShowImagesCollectCell.h"
#import "LGPhotoModel.h"
#import "JMBPassMakeViewController.h"
@interface XLFormShowImagesCell () <UICollectionViewDelegate, UICollectionViewDataSource,UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray<LGPhotoModel *> *albums;
@property (nonatomic, strong) LGPhotoModel *currentSelectAlbum;
@end
@implementation XLFormShowImagesCell

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ((object == self.textLabel && [keyPath isEqualToString:@"text"]) ||  (object == self.imageView && [keyPath isEqualToString:@"image"])){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
            [self.contentView setNeedsUpdateConstraints];
        }
    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
 [self initUI];
    }
    return self;
}

#pragma mark - XLFormDescriptorCell

-(void)configure
{
      [super configure];

      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadShowsImage) name:@"ReloadShowsImages"object:Nil];
}
-(void)reloadShowsImage
{
    self.albums = [SGFileUtil loadFiles:@"abc"];
    [self.ShowImagesviews reloadData];
}

-(void)initUI
{
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    UICollectionView * ShowImagesviews = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200) collectionViewLayout:layout];
    ShowImagesviews.alwaysBounceVertical = YES;
    ShowImagesviews.delegate = self;
    ShowImagesviews.dataSource = self;
    ShowImagesviews.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:ShowImagesviews];
    self.ShowImagesviews = ShowImagesviews;
}

#pragma mark -
#pragma mark UICollection DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLFormShowImagesCollectCell *cell = [XLFormShowImagesCollectCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    LGPhotoModel *album = self.albums[indexPath.row];
    cell.album = album;
    WS();
    [cell setAction:^{
        UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:@"是否删除此照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
        [ac showInView:self.superview];
        weakSelf.currentSelectAlbum = album;
    }];
    return cell;
}

/**
 高度

 @param rowDescriptor rowDescriptor description
 @return return value description
 */
+ (CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 200;
}
-(void)update
{
    [super update];
    self.albums = self.rowDescriptor.value;
     [self.ShowImagesviews reloadData];

}

#pragma mark UICollectionView Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50, 50);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 5, 10);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        [[NSFileManager defaultManager] removeItemAtPath:self.currentSelectAlbum.thumbURL.path error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:self.currentSelectAlbum.photoURL.path error:nil];
        self.albums =[SGFileUtil loadFiles:@"abc"];
    }
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary * userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@(indexPath.row),@"index", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidShowImagesClcik" object:userInfo];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReloadShowsImages" object:nil];
}
@end
