//
//  JMBVipController.m
//  密码生产器
//
//  Created by 张传奇 on 16/9/5.
//  Copyright © 2016年 张传奇. All rights reserved.
//

#import "JMBVipController.h"

@implementation JMBVipController
#pragma mark --摇一摇功能
- (BOOL)canBecomeFirstResponder
{
    return YES;// default is NO
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"开始摇动手机");
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"摇一摇成功");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"MDZZ，摇个蛋蛋" preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(alert) weakAlert = alert;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"%@",[weakAlert.textFields.firstObject text]);
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
    [self cutterViewToDocument];
    
}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"取消");
}
- (void)cutterViewToDocument
 {
     
//     allowScreenShot
         UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    
         UIGraphicsBeginImageContext(screenWindow.frame.size);
         [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
         UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
    
         NSData *screenShotPNG = UIImagePNGRepresentation(screenShot);
         NSError *error = nil;
         [screenShotPNG writeToFile:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"error.png"] options:NSAtomicWrite error:&error];
     }

-(Boolean)allowScreenShot
{
  
    return NO;
}

@end
