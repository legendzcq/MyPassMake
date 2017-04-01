//
//  JMBLoginController.m
//  密码生产器
//
//  Created by 张传奇 on 16/9/5.
//  Copyright © 2016年 张传奇. All rights reserved.
//

#import "JMBLoginController.h"
#import "JMBPassMakeViewController.h"
#import "QBImagePickerController.h"
#import "LGPhotoModel.h"
#import "LGPhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "CameraSessionView.h"
//#import "GTMBase64.h"
// #import <MediaPlayer/MediaPlayer.h>
@interface JMBLoginController() <QBImagePickerControllerDelegate>
{
   __block XLFormDescriptor * formDescriptor;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    JMBPassMakeViewController * makepass;
   BOOL isDisState;
}
@property(nonatomic,strong) NSMutableArray *photoModels;
@property(nonatomic,strong)XLFormRowDescriptor * ShowImages;
@property (nonatomic, strong) CameraSessionView *cameraView;
@end

NSString *const kName = @"name";
NSString *const kPassword = @"password";
NSString *const kEmail = @"email";
NSString *const KNameTag = @"NameTag";
NSString *const kUrl = @"url";
NSString *const kNotes = @"notes";
NSString *const KImageHead = @"ImageHead";
NSString *const KCreatTime = @"CreatTime";
NSString *const KlastTime = @"CreatTime";
NSString *const KEnclosure = @"Enclosure";
NSString *const KShowImages = @"ShowImages";
NSString *const kButton = @"button";
@implementation JMBLoginController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MakePassClick:) name:@"DidClickMakePassBtn" object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowImagesClick:) name:@"DidShowImagesClcik"object:Nil];

}
- (void)ShowImagesClick:(NSNotification *)notification
{
    
    
        NSDictionary * dic = [notification object];
    
        //进入单个图片查看选项
        LGPhotoViewController *vc = [LGPhotoViewController new];
        vc.browser = self;
        vc.index = [[dic objectForKey:@"index"] integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    
    
    


    
    
    
}

- (void)MakePassClick:(NSNotification *)notification
{

    makepass = [[JMBPassMakeViewController alloc]init];
    [self.navigationController pushViewController:makepass animated:YES];
    [makepass getPassWord:^(NSString *passWord) {
        XLFormRowDescriptor * temprow = [formDescriptor formRowWithTag:kPassword];
        temprow.value = passWord;
        [formDescriptor removeFormRowWithTag:kPassword];
        [formDescriptor addFormRow:temprow beforeRowTag:kUrl];
        
    }];
}

-(void)savePressed:(UIBarButtonItem * __unused)button
{
    NSLog(@"%@",formDescriptor.formValues);
    NSString * tempalert = [NSString stringWithFormat:@"%@",formDescriptor.formValues];
    
    NSArray * validationErrors = [self formValidationErrors];
    if (validationErrors.count > 0){
        [self showFormValidationError:[validationErrors firstObject]];
        return;
    }
    [self.tableView endEditing:YES];
    
    
    
    if ([UIAlertController class]){
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Valid Form", nil)
                                                                                  message:tempalert
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Valid Form", nil)
                                                          message:tempalert
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                otherButtonTitles:nil];
        [message show];
    }
}

-(id)init
{
    //    标题
    formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"登录"];
    formDescriptor.assignFirstResponderOnShow = YES;
    
    
    //    首行
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [formDescriptor addFormSection:section];
    
    
    NSArray * saveImageArray = @[@"123"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SetLoginImage" object:saveImageArray];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:KImageHead rowType:XLFormRowDescriptorTypeImageHeard title:@"用户头像"];
    [row.cellConfigAtConfigure setObject:@"登录" forKey:@"textField.placeholder"];
    [row.cellConfigAtConfigure setObject:[UIImage imageNamed:@"1"] forKey:@"IconImage.image"];
    row.required = YES;
    row.value = @"123";
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [formDescriptor addFormSection:section];
    
    
    
    
    //用户名称
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kName rowType:XLFormRowDescriptorTypeText title:@"用户名称"];
    row.required = YES;
    [section addFormRow:row];
    // 密码
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kPassword rowType:XLFormRowDescriptorTypePassword title:@"密码"];
    [section addFormRow:row];
    // 网站
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kUrl rowType:XLFormRowDescriptorTypeURL title:@"网站"];
    [section addFormRow:row];
    //标签
    row = [XLFormRowDescriptor formRowDescriptorWithTag:KNameTag rowType:XLFormRowDescriptorTypeEmail title:@"标签"];
    [row addValidator:[XLFormValidator emailValidator]];
    [section addFormRow:row];
    
    
    //修改日期
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:KlastTime rowType:XLFormRowDescriptorTypeInfo];
    row.title = @"修改日期";
    row.value =@"2016/9/5 at 9:45";
    row.required = YES;
    [section addFormRow:row];
    //创建日期
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:KCreatTime rowType:XLFormRowDescriptorTypeInfo];
    row.title = @"创建日期";
    row.value =@"1970/1/1 at 8:00";
    row.required = YES;
    [section addFormRow:row];
    
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kNotes rowType:XLFormRowDescriptorTypeTextView title:@"备注"];
    row.required = YES;
    [section addFormRow:row];
    
    
    // Button
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kButton rowType:XLFormRowDescriptorTypeButton title:@"添加照片"];
    row.action.formSelector = @selector(didTouchButton:);
    [section addFormRow:row];
    
    //    [self loadFiles];
    //    row = [XLFormRowDescriptor formRowDescriptorWithTag:KShowImages rowType:XLFormRowDescriptorTypeShowImages title:@"备注"];
    //     [section addFormRow:row];
    return [super initWithForm:formDescriptor];
}
    
-(void)didTouchButton:(XLFormRowDescriptor *)sender
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
////[self openCamera];
//    }]];
    WS();
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openCamera];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openImagePicker];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"导入文件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf loadFileManager];

        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    


}

-(void)loadFileManager
{

    NSString * cachsting = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"%@",cachsting);

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *folderContents = [fileManager
                               contentsOfDirectoryAtURL:[NSURL URLWithString:cachsting]
                               includingPropertiesForKeys:nil
                               options:0
                               error:&error];
    NSLog(@"%@",folderContents);
}



-(void)openCamera
{
    [self setNeedsStatusBarAppearanceUpdate];
    
    //Instantiate the camera view & assign its frame
    _cameraView = [[CameraSessionView alloc] initWithFrame:self.view.frame];
    
    //Set the camera view's delegate and add it as a subview
    _cameraView.delegate = self;
    
    //Apply animation effect to present the camera view
    CATransition *applicationLoadViewIn =[CATransition animation];
    [applicationLoadViewIn setDuration:0.6];
    [applicationLoadViewIn setType:kCATransitionReveal];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[_cameraView layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
    
    [self.view addSubview:_cameraView];

}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)openImagePicker
{

    QBImagePickerController *picker = [QBImagePickerController new];
    picker.maximumNumberOfSelection = 6;
    //    查看到的相册
    picker.assetCollectionSubtypes = @[
                                       @(PHAssetCollectionSubtypeSmartAlbumUserLibrary), //相机胶卷
                                       @(PHAssetCollectionSubtypeAlbumMyPhotoStream), //我的照片流
                                       @(PHAssetCollectionSubtypeSmartAlbumPanoramas) //全景图
                                       ];
    //    显示的类别
    picker.mediaType = QBImagePickerMediaTypeImage;//图片
    picker.delegate = self;
    picker.allowsMultipleSelection = YES;
    picker.showsNumberOfSelectedAssets = YES;
    [self presentViewController:picker animated:YES completion:nil];
}




#pragma mark - QBImagePickerController Delegate
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
    
    
    PHVideoRequestOptions * videoop = [[PHVideoRequestOptions alloc]init];
     // 最高质量的视频
    videoop.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
    // 可从iCloud中获取图片
    videoop.networkAccessAllowed = YES;
    
    PHImageRequestOptions *op = [[PHImageRequestOptions alloc] init];
    //   自动返回高质量的图片,需要等待返回的图像才能进一步作出反应
    op.synchronous = YES;
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:imagePickerController.view];
    [imagePickerController.view addSubview:hud];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    [hud showAnimated:YES];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    __block  NSInteger progressCount = 0;
    NSMutableArray *importAssets = @[].mutableCopy;
    NSInteger progressSum = assets.count * 2;
    void (^hudProgressBlock)(NSInteger currentProgressCount) = ^(NSInteger progressCount) {
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = (double)progressCount / progressSum;
            if (progressCount == progressSum) {
                [imagePickerController dismissViewControllerAnimated:YES completion:nil];
                [hud hideAnimated:YES];
            
                [self setupView:[SGFileUtil loadFiles:@"abc"]];
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    [PHAssetChangeRequest deleteAssets:importAssets];
                } completionHandler:nil];
            }
        });
    };
    NSLog(@"%lu",(unsigned long)assets.count);
    for (int i = 0; i < assets.count; i++) {
        PHAsset *tempasset = assets[i];
        [importAssets addObject:tempasset];
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        NSString *fileName = [[NSString stringWithFormat:@"%@%@",dateStr,@(i)] MD5];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString * tempName = [NSString string];
            if (tempasset.mediaType == PHAssetMediaTypeImage ) {
                tempName =[NSString stringWithFormat:@"Image_"];
                [imageManager requestImageForAsset:tempasset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:op resultHandler:^(UIImage *result, NSDictionary *info) {
                    [SGFileUtil savePhoto:result toRootPath:[SGFileUtil getRootPath:@"abc"] withName:[NSString stringWithFormat:@"%@%@",tempName,fileName]];
               hudProgressBlock(++progressCount);
                }];
            }else if (tempasset.mediaType == PHAssetMediaTypeVideo )
            {

                 tempName =[NSString stringWithFormat:@"Video_"];
                [imageManager requestAVAssetForVideo:tempasset options:videoop resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                    [SGFileUtil saveVideo:asset toRootPath:[SGFileUtil getRootPath:@"abc"] withName:[NSString stringWithFormat:@"%@%@",tempName,fileName]];
                     hudProgressBlock(++progressCount);
                    
                    
                }];
                
            }
            
            
            [imageManager requestImageForAsset:tempasset targetSize:CGSizeMake(120, 120) contentMode:PHImageContentModeAspectFill options:op resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [SGFileUtil saveThumb:result toRootPath:[SGFileUtil getRootPath:@"abc"] withName:[NSString stringWithFormat:@"%@%@",tempName,fileName]];
                hudProgressBlock(++progressCount);
            }];
        });
    }
    
    
}

-(void)setupView:(NSMutableArray *)photoModels
{
    self.photoModels  = photoModels;
    XLFormRowDescriptor * ShowImages = [XLFormRowDescriptor formRowDescriptorWithTag:KShowImages rowType:XLFormRowDescriptorTypeShowImages title:@"备注"];
    ShowImages.value = self.photoModels;
    if (self.ShowImages)
        [formDescriptor removeFormRowWithTag:KShowImages];
    
    [formDescriptor addFormRow:ShowImages afterRowTag:kButton];
    self.ShowImages = ShowImages;
}

#pragma mark - CameraSessionView Delegate
-(void)didCaptureImage:(UIImage *)image {
    NSLog(@"CAPTURED IMAGE");
    [self.cameraView removeFromSuperview];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [[NSString stringWithFormat:@"%@",dateStr] MD5];
    NSString * tempName =@"Image_";
    [SGFileUtil savePhoto:image toRootPath:[SGFileUtil getRootPath:@"abc"] withName:[NSString stringWithFormat:@"%@%@",tempName,fileName]];
    [SGFileUtil saveThumb:image toRootPath:[SGFileUtil getRootPath:@"abc"] withName:[NSString stringWithFormat:@"%@%@",tempName,fileName]];
    [self setupView:[SGFileUtil loadFiles:@"abc"]];

}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //Show error alert if image could not be saved
    if (error) [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

-(void)dealloc
{
 [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DidShowImagesClcik" object:nil];
}




@end
