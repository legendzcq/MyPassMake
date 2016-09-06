//
//  JMBPassMakeViewController.h
//  密码生产器
//
//  Created by 张传奇 on 16/8/29.
//  Copyright © 2016年 张传奇. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^JMBPassMakeViewGetPassBlock)(NSString * passWord);
@interface JMBPassMakeViewController : UIViewController

-(void)getPassWord:(JMBPassMakeViewGetPassBlock) getPassBlock;
@end
