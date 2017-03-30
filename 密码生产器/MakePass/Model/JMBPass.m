//
//  JMBPass.m
//  密码生产器
//
//  Created by 张传奇 on 16/8/29.
//  Copyright © 2016年 张传奇. All rights reserved.
//

#import "JMBPass.h"
#define GET_ARRAY_LEN(array,len){len = (sizeof(array) / sizeof(array[0]));}
@implementation JMBPass
+(NSString *)passMakeLenth:(int)Alllength isNum:(int)NumLength singleNum:(int)singleNum isLow:(BOOL)isLow isReplace:(BOOL)isReplace
{
    
    NSArray * tempZM = [[NSArray alloc]initWithObjects:@0,@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21,@22,@23,@24,@25, nil];
     NSMutableArray * tempSZ = [[NSMutableArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
//        NSMutableArray * tempTS = [[NSMutableArray alloc]initWithObjects:@"!",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"_",@"+",@"-",@"=", nil];
    NSMutableArray * tempTS = [[NSMutableArray alloc]initWithObjects:@"#",@"~",@"`",@"!",@"@",@"$",@"^",@"*",@"(",@")",@"_",@"+",@"-",@"=",@"[",@"]",@"{",@"}",@"\\",@";",@"'",@":",@"\"",@",",@".",@"<",@">",@"/",@"?",@"%", nil];
    NSMutableString *str = [NSMutableString stringWithString:@""];
    NSMutableArray *myA = [NSMutableArray array];

    
    int ZMNum = Alllength-NumLength-singleNum;//字母长度
    int CapLen = 0;//大写字母次数
    int lowLen = 0;//小写字母次数
    if (ZMNum>0) {
//    正常情况 总体长度>数字+符号   相减得到的是字母的长度然后在随机一个大写字母的长度   最后为小写字母的长度  当有判断为全为小写字母后 设置大写字母为0
        if (isLow) {
            if ((!isReplace) && (ZMNum>26) ) {
                lowLen=26;
            }else
            {
            lowLen = ZMNum;
            }
            
        }else
        {
            CapLen =(arc4random() % ZMNum);
            lowLen =ZMNum-CapLen;
        }
    }else
    {
        if (NumLength>=Alllength) {
            //     特殊情况  数字 > 总体长度
            NumLength =Alllength;
            singleNum =0;
            
        }else
        {//    特殊情况 数字 <中体长度 < 数字 + 符号  解决办法是先满足数字然后再满足符号
            singleNum = Alllength-NumLength;
        
        }
        CapLen =0;
        lowLen =0;
    }
//    NSLog(@"NumLength:%d--singleNum:%d--CapLen:%d--lowLen:%d--Alllength:%d",NumLength,singleNum,CapLen,lowLen,Alllength);
//    数字模块
    for (int index = 0; index<NumLength; index++) {
        
        int sy =arc4random() % tempSZ.count;
        [myA addObject:tempSZ[sy]];
        if (!isReplace) {
            [tempSZ removeObjectAtIndex:sy];
        }
        
    }
    

//特殊字符
    for (int index = 0; index<singleNum; index++) {
        
        int sy =arc4random() % tempTS.count;
        [myA addObject:tempTS[sy]];
        if (!isReplace) {
            [tempTS removeObjectAtIndex:sy];
        }
        
    }
    
    
    


//    大写字母
      NSMutableArray * Captemp = [[NSMutableArray alloc]initWithArray:tempZM];
        for (int index=0; index < CapLen; index++) {
            int abc =arc4random() % Captemp.count;
            char up[] = {[Captemp[abc] intValue] + 'A','\0'};
            if (!isReplace) {
              [Captemp removeObjectAtIndex:abc];
            }
            [myA addObject:[NSString stringWithUTF8String:up]];
            
        }

//    小写字母
    
    
    NSMutableArray * lowtemp = [[NSMutableArray alloc]initWithArray:tempZM];

        for (int index=0; index<lowLen; index++) {
            int abc =arc4random() % lowtemp.count;
            char low[] = {[lowtemp[abc] intValue] + 'a','\0'};
            if (!isReplace) {
              [lowtemp removeObjectAtIndex:abc];
            }
     
            [myA addObject:[NSString stringWithUTF8String:low]];
        }

    

    
        for (int index=[myA count]; index>0; index--) {
            int resNum =(arc4random() % index);
            
            [str appendString:[myA objectAtIndex:resNum]];
            [myA removeObjectAtIndex:resNum];
        }

    
    
    
    return str;
}
@end
