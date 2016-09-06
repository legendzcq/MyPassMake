//
//  JMBPassMakeView.h
//  密码生产器
//
//  Created by 张传奇 on 16/8/29.
//  Copyright © 2016年 张传奇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JMBPassMakeView;
typedef void(^JMBPassMakeViewNeedReloadBlock)(int Lvalue,int Nvalue, int Svalue, BOOL isLowe,BOOL IsReplace);
typedef void(^JMBPassMakeViewBtnReloadBlock)(void);


@interface JMBPassMakeView : UIView
@property(nonatomic,weak)UILabel * lengthNum;
@property(nonatomic,weak)UITextField * passCont;
- (void)setlengthcontAction:(JMBPassMakeViewNeedReloadBlock)lengthcontBlock;
- (void)setCopyBtnAction:(JMBPassMakeViewBtnReloadBlock)copyBlock;
- (void)setMakeBtnAction:(JMBPassMakeViewBtnReloadBlock)makeBlock;
@end
