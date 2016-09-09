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
#import "SGPhotoModel.h"
#import "SGPhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
//#import "GTMBase64.h"
// #import <MediaPlayer/MediaPlayer.h>
@interface JMBLoginController() <QBImagePickerControllerDelegate>
{
   __block XLFormDescriptor * formDescriptor;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    JMBPassMakeViewController * makepass;
}
@property(nonatomic,strong) NSMutableArray *photoModels;
@property(nonatomic,strong)XLFormRowDescriptor * ShowImages;

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
        SGPhotoViewController *vc = [SGPhotoViewController new];
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
    formDescriptor = [XLFormDescriptor formDescriptorWithTitle:@"登录"];
    formDescriptor.assignFirstResponderOnShow = YES;
    
    
    section = [XLFormSectionDescriptor formSectionWithTitle:@""];
    [formDescriptor addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:KImageHead rowType:XLFormRowDescriptorTypeImageHeard title:@"用户头像"];
    [row.cellConfigAtConfigure setObject:@"登录" forKey:@"textField.placeholder"];
    row.required = YES;
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
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kButton rowType:XLFormRowDescriptorTypeButton title:@"添加附件"];
    row.action.formSelector = @selector(didTouchButton:);
    [section addFormRow:row];
    
    [self loadFiles];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:KShowImages rowType:XLFormRowDescriptorTypeShowImages title:@"备注"];
     [section addFormRow:row];
    return [super initWithForm:formDescriptor];
}
    
-(void)didTouchButton:(XLFormRowDescriptor *)sender
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
//    picker.mediaType = QBImagePickerMediaTypeImage;//图片
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
                [self loadFiles];
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
                    [SGFileUtil savePhoto:result toRootPath:[SGFileUtil getRootPath] withName:[NSString stringWithFormat:@"%@%@",tempName,fileName]];
               hudProgressBlock(++progressCount);
                }];
            }else if (tempasset.mediaType == PHAssetMediaTypeVideo )
            {

                 tempName =[NSString stringWithFormat:@"Video_"];
                [imageManager requestAVAssetForVideo:tempasset options:videoop resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                    [SGFileUtil saveVideo:asset toRootPath:[SGFileUtil getRootPath] withName:[NSString stringWithFormat:@"%@%@",tempName,fileName]];
                     hudProgressBlock(++progressCount);
                    
                    
                }];
                
            }
            
            
            [imageManager requestImageForAsset:tempasset targetSize:CGSizeMake(120, 120) contentMode:PHImageContentModeAspectFill options:op resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [SGFileUtil saveThumb:result toRootPath:[SGFileUtil getRootPath] withName:[NSString stringWithFormat:@"%@%@",tempName,fileName]];
                hudProgressBlock(++progressCount);
            }];
        });
    }
    
    
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

    self.photoModels  = photoModels;
    XLFormRowDescriptor * ShowImages = [XLFormRowDescriptor formRowDescriptorWithTag:KShowImages rowType:XLFormRowDescriptorTypeShowImages title:@"备注"];
    ShowImages.value = self.photoModels;
    if (self.ShowImages)
    [formDescriptor removeFormRowWithTag:KShowImages];
    
    [formDescriptor addFormRow:ShowImages afterRowTag:kButton];
    self.ShowImages = ShowImages;
    


}
-(void)dealloc
{
 [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DidShowImagesClcik" object:nil];
}



@end
