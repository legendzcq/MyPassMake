//
//  SGFileUtil.m
//  SGSecurityAlbum
//
//  Created by soulghost on 9/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGFileUtil.h"
 #import <MediaPlayer/MediaPlayer.h>
#import "GTMBase64.h"
@implementation SGFileUtil

+ (instancetype)sharedUtil {
    static SGFileUtil *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

+ (NSString *)getFileNameFromPath:(NSString *)filePath {
    return [[filePath componentsSeparatedByString:@"/"] lastObject];
}

+ (NSString *)photoPathForRootPath:(NSString *)rootPath {
    return [rootPath stringByAppendingPathComponent:@"Photo"];
}

+ (NSString *)thumbPathForRootPath:(NSString *)rootPath {
    return [rootPath stringByAppendingPathComponent:@"Thumb"];
}

+ (void)savePhoto:(UIImage *)image toRootPath:(NSString *)rootPath withName:(NSString *)name {
    NSData *imageDate = UIImagePNGRepresentation(image);
    rootPath = [self photoPathForRootPath:rootPath];
    NSFileManager *mgr = [NSFileManager defaultManager];
    if(![mgr fileExistsAtPath:rootPath isDirectory:nil]) {
        [mgr createDirectoryAtPath:rootPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    rootPath = [rootPath stringByAppendingPathComponent:name];
    [imageDate writeToFile:rootPath atomically:YES];
}

+ (void)saveVideo:(AVAsset *)asset toRootPath:(NSString *)rootPath withName:(NSString *)name {

    rootPath = [self photoPathForRootPath:rootPath];
    NSFileManager *mgr = [NSFileManager defaultManager];
    if(![mgr fileExistsAtPath:rootPath isDirectory:nil]) {
        [mgr createDirectoryAtPath:rootPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
 __block   NSString * temprootPath = [rootPath stringByAppendingPathComponent:name];
    temprootPath = [NSString stringWithFormat:@"%@.mp4",temprootPath];

//    [MBProgressHUD showMessage:@"请等待.."];
    
    
    
//    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
    
    NSLog(@"%@",compatiblePresets);
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        
//        NSString * resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
//        
//        NSLog(@"resultPath = %@",resultPath);
        
        exportSession.outputURL = [NSURL fileURLWithPath:temprootPath];
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         
         {
             
             switch (exportSession.status) {
                     
                 case AVAssetExportSessionStatusUnknown:
                     
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     
                     break;
                     
                 case AVAssetExportSessionStatusWaiting:
                     
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     
                     break;
                     
                 case AVAssetExportSessionStatusExporting:
                     
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     
                     break;
                     
                 case AVAssetExportSessionStatusCompleted:
                     
                     NSLog(@"AVAssetExportSessionStatusCompleted");
                     if ([SGFileUtil func_encodeFile:temprootPath]) {
                         NSLog(@"加密成功");
                     }else
                         NSLog(@"加密失败");
//                     [MBProgressHUD hideHUD];
                     break;
                     
                 case AVAssetExportSessionStatusFailed:
                     
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     
                     break;
                     
             }
             
         }];
        
    }
    
    
    
    
    
    
    
    
}

+ (void)saveThumb:(UIImage *)image toRootPath:(NSString *)rootPath withName:(NSString *)name {
    NSData *imageDate = UIImagePNGRepresentation(image);
    rootPath = [self thumbPathForRootPath:rootPath];
    NSFileManager *mgr = [NSFileManager defaultManager];
    if(![mgr fileExistsAtPath:rootPath isDirectory:nil]) {
        [mgr createDirectoryAtPath:rootPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    rootPath = [rootPath stringByAppendingPathComponent:name];
    [imageDate writeToFile:rootPath atomically:YES];
}

+ (NSString *)getRootPath {

    NSString * rootPath = [DocumentPath stringByAppendingPathComponent:@"tempabc"];
    NSFileManager *mgr = [NSFileManager defaultManager];
    if (![mgr fileExistsAtPath:rootPath isDirectory:nil]) {
        [mgr createDirectoryAtPath:rootPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return rootPath;
}

// 加密函数
+(BOOL)func_encodeFile:(NSString *)filePath
{
    //NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/test.png"];
//    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/iphone4.mov"];
    
    //文件路径转换为NSData
    NSData *imageDataOrigin = [NSData dataWithContentsOfFile:filePath];
    
//    // 对前1000位进行异或处理
//    unsigned char * cByte = (unsigned char*)[imageDataOrigin bytes];
//    for (int index = 0; (index < [imageDataOrigin length]) && (index < 1000); index++, cByte++)
//    {
//        *cByte = (*cByte) ^ arrayForEncode[index];
//    }
    
    //对NSData进行base64编码
    NSData *imageDataEncode = [GTMBase64 encodeData:imageDataOrigin];
    
  return  [imageDataEncode writeToFile:filePath atomically:YES];
}

// 解密函数
+(BOOL)func_decodeFile:(NSString *)filePath
{
    //NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/test.png"];
//    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/iphone4.mov"];
    
    // 读取被加密文件对应的数据
    NSData *dataEncoded = [NSData dataWithContentsOfFile:filePath];
    
    // 对NSData进行base64解码
    NSData *dataDecode = [GTMBase64 decodeData:dataEncoded];
    
//    // 对前1000位进行异或处理
//    unsigned char * cByte = (unsigned char*)[dataDecode bytes];
//    for (int index = 0; (index < [dataDecode length]) && (index < 10); index++, cByte++)
//    {
//        *cByte = (*cByte) ^ arrayForEncode[index];
//    }
    
   return  [dataDecode writeToFile:filePath atomically:YES];
}

@end
