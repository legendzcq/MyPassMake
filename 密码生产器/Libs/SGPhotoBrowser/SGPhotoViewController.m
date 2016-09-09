//
//  SGPhotoViewController.m
//  SGSecurityAlbum
//
//  Created by soulghost on 10/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGPhotoViewController.h"
//#import "SGPhotoBrowser.h"
#import "SGPhotoView.h"
#import "SGPhotoModel.h"
#import "SGPhotoToolBar.h"
#import "SGUIKit.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JMBLoginController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface SGPhotoViewController ()

@property (nonatomic, assign) BOOL isBarHidden;
@property (nonatomic, weak) SGPhotoView *photoView;
@property (nonatomic, weak) SGPhotoToolBar *toolBar;
@property (nonatomic, strong)__block SGPhotoModel *currentPhoto;
@property (strong, nonatomic) AVPlayerViewController *playerVC;
@end

@implementation SGPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    WS();
    [self.photoView setSingleTapHandlerBlock:^{
        [weakSelf toggleBarState];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)setupView {
    SGPhotoView *photoView = [[SGPhotoView alloc] initWithFrame:[self getPhotoViewFrame]];
    self.photoView = photoView;
    self.photoView.controller = self;
    self.photoView.index = self.index;

    [self.view addSubview:photoView];
    SGPhotoToolBar *tooBar = [[SGPhotoToolBar alloc] initWithFrame:[self getBarFrame]];
    self.toolBar = tooBar;
    [self.view addSubview:tooBar];
    WS();
    [self.toolBar setButtonActionHandlerBlock:^(UIBarButtonItem *sender) {
        switch (sender.tag) {
            case SGPhotoToolBarTrashTag:
                [weakSelf trashAction];
                break;
            case SGPhotoToolBarExportTag:
                [weakSelf exportAction];
                break;
            default:
                break;
        }
    }];
}

- (void)layoutViews {
    self.photoView.frame = [self getPhotoViewFrame];
    [self.photoView layoutImageViews];
    self.toolBar.frame = [self getBarFrame];
}

- (CGRect)getPhotoViewFrame {
    CGFloat x = -PhotoGutt;
    CGFloat y = 0;
    CGFloat w = self.view.bounds.size.width + 2 * PhotoGutt;
    CGFloat h = self.view.bounds.size.height;
    return CGRectMake(x, y, w, h);
}

- (CGRect)getBarFrame {
    CGFloat barW = self.view.bounds.size.width;
    CGFloat barH = 44;
    CGFloat barX = 0;
    CGFloat barY = self.view.bounds.size.height - barH;
    return CGRectMake(barX, barY, barW, barH);
}
//点击
- (void)toggleBarState {
    
    SGPhotoModel * model =[self.photoView getcurrentPhoto];
    NSString * fileName = [SGFileUtil getFileNameFromPath:model.photoURL.path];
    if ([fileName hasPrefix:@"Video_"]) {
    
        NSURL *url = model.photoURL;
        [SGFileUtil func_decodeFile:url.path];
        AVURLAsset *anAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
        [self updateUserInterfaceForDuration:anAsset];
        
    }else if ([fileName hasPrefix:@"Image_"])
    {
        self.isBarHidden = !self.isBarHidden;
        [[UIApplication sharedApplication] setStatusBarHidden:self.isBarHidden withAnimation:NO];
        [self.navigationController setNavigationBarHidden:self.isBarHidden animated:YES];
        [UIView animateWithDuration:0.35 animations:^{
            self.toolBar.alpha = self.isBarHidden ? 0 : 1.0f;
        }];
    }

    
}
-(void)updateUserInterfaceForDuration:(AVURLAsset *)anAsset
{
    AVPlayerItem *item =[[AVPlayerItem alloc]initWithAsset:anAsset];
    
    // 3.创建AVPlayer
    AVPlayer * player = [[AVPlayer alloc] initWithPlayerItem:item];
    
    // 4.添加AVPlayerLayer
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
    playerVC.player = player;
    playerVC.view.frame = self.view.frame;
//        [self.view addSubview:playerVC.view];
//    [self.navigationController pushViewController:playerVC animated:YES];
    [self presentViewController:playerVC animated:YES completion:nil];
    self.playerVC = playerVC;
    //调用控制器的属性player的开始播放方法
    [self.playerVC.player play];
}
#pragma mark - ToolBar Action
- (void)trashAction {
    [[[SGBlockActionSheet alloc] initWithTitle:@"是否删除此照片" callback:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 0) {

            SGPhotoModel * tempModel =[self.photoView getcurrentPhoto];
                [[NSFileManager defaultManager] removeItemAtPath:tempModel.thumbURL.path  error:nil];
                [[NSFileManager defaultManager] removeItemAtPath:tempModel.photoURL.path error:nil];
                 [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadShowsImages" object:nil];
             
        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitlesArray:nil] showInView:self.view];
}

- (void)exportAction {
    [[[SGBlockActionSheet alloc] initWithTitle:@"保存到手机" callback:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            ALAssetsLibrary *lib = [ALAssetsLibrary new];
            UIImage *image = self.photoView.currentImageView.innerImageView.image;
            [MBProgressHUD showMessage:@"保存中..."];
            [lib writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"保存成功"];
            }];
        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitlesArray:@[@"保存"]] showInView:self.view];
}

#pragma mark - dealloc 
- (void)orientationDidChanged:(UIDeviceOrientation)orientation {
    [self layoutViews];
}

@end
