//
//  XLFormShowImagesCell.m
//  密码生产器
//
//  Created by 张传奇 on 16/9/6.
//  Copyright © 2016年 张传奇. All rights reserved.
//

#import "XLFormShowImagesCell.h"
#import "XLFormShowImagesCollectCell.h"
#import "SGPhotoModel.h"
@interface XLFormShowImagesCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray<SGPhotoModel *> *albums;

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

    }
    return self;
}

#pragma mark - XLFormDescriptorCell

-(void)configure
{
      [super configure];

    [self loadFiles];
      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self initUI];


    
    
}

-(void)initUI
{
//    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
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

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLFormShowImagesCollectCell *cell = [XLFormShowImagesCollectCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    SGPhotoModel *album = self.albums[indexPath.row];
    cell.album = album;
//    WS();
//    [cell setAction:^{
//        UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:@"Operation" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
//        [ac showInView:self.superview];
//        weakSelf.currentSelectAlbum = album;
//    }];
    return cell;
}
+ (CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 200;
}


#pragma mark UICollectionView Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50, 50);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 5, 10);
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return (!self.rowDescriptor.isDisabled);
}

-(void)highlight
{
    [super highlight];
    self.textLabel.textColor = self.tintColor;
}

-(void)unhighlight
{
    [super unhighlight];
    [self.formViewController updateFormRow:self.rowDescriptor];
}

- (void)loadFiles {
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSString *photoPath = [SGFileUtil photoPathForRootPath:[SGFileUtil getRootPath]];
    NSString *thumbPath = [SGFileUtil thumbPathForRootPath:[SGFileUtil getRootPath]];
    NSMutableArray *photoModels = @[].mutableCopy;
    NSArray *fileNames = [mgr contentsOfDirectoryAtPath:photoPath error:nil];
    for (NSUInteger i = 0; i < fileNames.count; i++) {
        NSString *fileName = fileNames[i];
        NSURL *photoURL = [NSURL fileURLWithPath:[photoPath stringByAppendingPathComponent:fileName]];
        NSURL *thumbURL = [NSURL fileURLWithPath:[thumbPath stringByAppendingPathComponent:fileName]];
        SGPhotoModel *model = [SGPhotoModel new];
        model.photoURL = photoURL;
        model.thumbURL = thumbURL;
        [photoModels addObject:model];
    }
    self.albums = photoModels;
    [self.ShowImagesviews reloadData];
}
@end
