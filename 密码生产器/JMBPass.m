//
//  JMBPass.m
//  密码生产器
//
//  Created by 张传奇 on 16/8/29.
//  Copyright © 2016年 张传奇. All rights reserved.
//

#import "JMBPass.h"

@implementation JMBPass
+(NSString *)passMakeLenth:(int)Alllength isNum:(int)NumLength singleNum:(int)singleNum isLow:(BOOL)isLow isReplace:(BOOL)isReplace
{
    
    
    char te[] = {'!','@','#','$','%','^','&','*','(',')','_','+','-','='};
    
    NSMutableString *str = [NSMutableString stringWithString:@""];
    
    
    NSMutableArray *myA = [NSMutableArray array];
    BOOL isR=NO;
    do{
        isR=NO;
        for (int index = 0; index<NumLength; index++) {
            char shuzi[] = {(arc4random() % 10) + '0','\0'};
            if ((index>0) &&([[myA lastObject] isEqualToString:[NSString stringWithUTF8String:shuzi]])) {
                isR=YES;
            }
            [myA addObject:[NSString stringWithUTF8String:shuzi]];
            
            
        }
        if (!isReplace) {
            isR = NO;
        }
    }while (isR);
    
    do{
        isR=NO;
        for (int index = 0; index < singleNum; index++) {
            char teshu[] = {te[((arc4random() % (sizeof(te)/1)))],'\0'};
            if ((index>0) &&([[myA lastObject] isEqualToString:[NSString stringWithUTF8String:teshu]])) {
                isR=YES;
            }
            [myA addObject:[NSString stringWithUTF8String:teshu]];
        }
        if (!isReplace) {
            isR = NO;
        }
    }while (isR);
    int ZMNum = Alllength-NumLength-singleNum;
    int CapLen = 0;
    int lowLen = 0;
    if (isLow) {
        lowLen = ZMNum;
    }else
    {
        CapLen =(arc4random() % ZMNum);
        lowLen =ZMNum-CapLen;
    }
    do{
        isR=NO;
        for (int index=0; index < CapLen; index++) {
            char up[] = {(arc4random() % 27) + 'A','\0'};
            if ((index>0) &&([[myA lastObject] isEqualToString:[NSString stringWithUTF8String:up]])) {
                isR=YES;
            }
            [myA addObject:[NSString stringWithUTF8String:up]];
        }
        if (!isReplace) {
            isR = NO;
        }
    }while (isR);
    do{
        isR=NO;
        for (int index=0; index<lowLen; index++) {
            char low[] = {(arc4random() % 27) + 'a','\0'};
            if ((index>0) &&([[myA lastObject] isEqualToString:[NSString stringWithUTF8String:low]])) {
                isR=YES;
            }
            [myA addObject:[NSString stringWithUTF8String:low]];
        }
        if (!isReplace) {
            isR = NO;
        }
    }while (isR);

    
        for (int index=[myA count]; index>0; index--) {
            int resNum =(arc4random() % index);
            
            [str appendString:[myA objectAtIndex:resNum]];
            [myA removeObjectAtIndex:resNum];
        }

    
    
    
    return str;
}
@end
