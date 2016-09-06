//
//  JMBLoginController.m
//  密码生产器
//
//  Created by 张传奇 on 16/9/5.
//  Copyright © 2016年 张传奇. All rights reserved.
//

#import "JMBLoginController.h"
#import "JMBPassMakeViewController.h"
@interface JMBLoginController()
{
   __block XLFormDescriptor * formDescriptor;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    JMBPassMakeViewController * makepass;
}

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
@implementation JMBLoginController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MakePassClick:) name:@"DidClickMakePassBtn" object:Nil];
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

    //附件
    row = [XLFormRowDescriptor formRowDescriptorWithTag:KEnclosure rowType:XLFormRowDescriptorTypeEmail title:@"附件"];
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
    [section addFormRow:row];
    
    
    return [super initWithForm:formDescriptor];
}
    
    
@end
