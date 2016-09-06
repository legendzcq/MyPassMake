//
//  JMBPass.h
//  密码生产器
//
//  Created by 张传奇 on 16/8/29.
//  Copyright © 2016年 张传奇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMBPass : NSObject
+(NSString *)passMakeLenth:(int)Alllength isNum:(int)NumLength singleNum:(int)singleNum isLow:(BOOL)isLow isReplace:(BOOL)isReplace;
@end
