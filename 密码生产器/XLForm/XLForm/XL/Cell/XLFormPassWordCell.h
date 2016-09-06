//
//  XLFormPassWordCell.h
//  密码生产器
//
//  Created by 张传奇 on 16/9/5.
//  Copyright © 2016年 张传奇. All rights reserved.
//

#import "XLFormBaseCell.h"

@interface XLFormPassWordCell : XLFormBaseCell<XLFormReturnKeyProtocol>
@property (nonatomic, readonly) UILabel * textLabel;
@property (nonatomic, readonly) UITextField * textField;
@property (nonatomic) NSNumber *textFieldLengthPercentage;

@end
