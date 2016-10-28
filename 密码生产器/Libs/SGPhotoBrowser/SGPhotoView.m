//
//  SGPhotoView.m
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGPhotoView.h"
#import "SGPhotoModel.h"
#import "UIImageView+WebCache.h"
#import "SGPhotoBrowser.h"
#import "SGPhotoModel.h"
#import "SGZoomingImageView.h"
#import "SGPhotoViewController.h"

@interface SGPhotoView () <UIScrollViewDelegate> {
    CGFloat _pageW;
}

@property (nonatomic, copy) SGPhotoViewTapHandlerBlcok singleTapHandler;
@property (nonatomic, copy)getcurrentPhotoBlock currentBlock;
@property (nonatomic, strong) NSArray<SGZoomingImageView *> *imageViews;
@property (nonatomic, assign) NSInteger titleIndex;
@property(nonatomic,strong) NSMutableArray *photoModels;
@end

@implementation SGPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        添加初始化信息
        [self commonInit];
//        加载资源
        self.photoModels = [SGFileUtil loadFiles:@"abc"];
//        获取
        [self getImages];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor blackColor];
    self.pagingEnabled = YES;
    self.delegate = self;
}

- (void)handleDoubleTap {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.currentImageView toggleState:YES];
}


- (void)layoutImageViews {
    NSInteger count = self.photoModels.count;
    CGFloat imageViewWidth = self.bounds.size.width;
    _pageW = imageViewWidth;
    self.contentSize = CGSizeMake(count * imageViewWidth, 0);
    for (NSUInteger i = 0; i < self.imageViews.count; i++) {
        SGZoomingImageView *imageView = self.imageViews[i];
        imageView.isOrigin = NO;
        CGRect frame = (CGRect){imageViewWidth * i, 0, imageViewWidth, self.bounds.size.height};
        imageView.frame = CGRectInset(frame, PhotoGutt, 0);
        [self addSubview:imageView];
        [imageView scaleToFitAnimated:NO];
    }
    self.contentOffset = CGPointMake(self.index * _pageW, 0);
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    self.contentOffset = CGPointMake(index * _pageW, 0);
    [self loadImageAtIndex:index];
    [self updateNavBarTitleWithIndex:index];
}

- (void)updateNavBarTitleWithIndex:(NSInteger)index {
    self.controller.navigationItem.title = [NSString stringWithFormat:@"%@ Of %lu",@(index + 1),(unsigned long)self.photoModels.count];
}

- (void)loadImageAtIndex:(NSInteger)index {
    self.titleIndex = index;
    NSInteger count = self.photoModels.count;
    for (NSInteger i = 0; i < count; i++) {
        SGPhotoModel *model = self.photoModels[i];
        SGZoomingImageView *imageView = self.imageViews[i];
        if (i == index) {
            self.currentImageView = imageView;
        } else {
            [imageView scaleToFitIfNeededAnimated:NO];
        }
        NSURL *photoURL = model.photoURL;
        NSURL *thumbURL = model.thumbURL;
        if (i >= index - 1 && i <= index + 1) {
            if (imageView.isOrigin) continue;
            [imageView.innerImageView sg_setImageWithURL:photoURL model:model];
            imageView.isOrigin = YES;
            [imageView scaleToFitAnimated:NO];
        } else {
            if (!imageView.isOrigin) continue;
            [imageView.innerImageView sg_setImageWithURL:thumbURL model:model];
            imageView.isOrigin = NO;
            [imageView scaleToFitAnimated:NO];
        }
    }
}

- (void)setCurrentImageView:(SGZoomingImageView *)currentImageView {
    if (_currentImageView != nil) {
        [_currentImageView setSingleTapHandler:nil];
    }
    _currentImageView = currentImageView;
    WS();
    [_currentImageView setSingleTapHandler:^{
        if (weakSelf.singleTapHandler) {
            weakSelf.singleTapHandler();
        }
    }];
}

- (void)setSingleTapHandlerBlock:(SGPhotoViewTapHandlerBlcok)handler {
    self.singleTapHandler = handler;
}

-(SGPhotoModel *)getcurrentPhoto
{
    return self.photoModels[_index];
}


- (void)setTitleIndex:(NSInteger)titleIndex {
    if (_titleIndex == titleIndex) return;
    _titleIndex = titleIndex;
    [self updateNavBarTitleWithIndex:titleIndex];
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = (offsetX + _pageW * 0.5f) / _pageW;
    if (_index != index) {
        _index = index;
        [self loadImageAtIndex:_index];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    self.titleIndex = (offsetX + _pageW * 0.5f) / _pageW;
}




#pragma mark --------------------------------
#pragma mark- 设置缩略图界面数据 后期需要修改
- (void)getImages {
    NSInteger count = self.photoModels.count;
    NSMutableArray *imageViews = @[].mutableCopy;
    for (NSUInteger i = 0; i < count; i++) {
        SGZoomingImageView *imageView = [SGZoomingImageView new];
        SGPhotoModel *model = self.photoModels[i];;
        [imageView.innerImageView sg_setImageWithURL:model.thumbURL model:model];
        imageView.isOrigin = NO;
        [imageViews addObject:imageView];
        [self addSubview:imageView];
        [imageView scaleToFitAnimated:NO];
    }
    self.imageViews = imageViews;
    [self layoutImageViews];
}




@end
