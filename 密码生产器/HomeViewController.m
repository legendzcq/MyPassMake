//
//  HomeViewController.m
//  密码生产器
//
//  Created by 张传奇 on 16/9/5.
//  Copyright © 2016年 张传奇. All rights reserved.
//

#import "HomeViewController.h"
#import "JMBLoginController.h"
#import "JMBVipController.h"
#import "ShowDocumentViewController.h"
NSString * const JMBLOGINCON = @"JMBLoginController";
NSString * const JMBVIPCON = @"JMBVipController";

@implementation HomeViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
     [self initializeForm];
}
#pragma mark - Helper

-(void)initializeForm
{
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSectionWithTitle:@"存储模板"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:JMBLOGINCON rowType:XLFormRowDescriptorTypeButton title:@"登录选项"];
    row.action.viewControllerClass = [JMBLoginController class];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:JMBVIPCON rowType:XLFormRowDescriptorTypeButton title:@"导入文件功能"];
    row.action.viewControllerClass = [JMBVipController class];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ShowDocumentViewController" rowType:XLFormRowDescriptorTypeButton title:@"文件预览"];
    row.action.viewControllerClass = [ShowDocumentViewController class];
    [section addFormRow:row];
    
    self.form = form;
}
@end
