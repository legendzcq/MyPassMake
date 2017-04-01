//
//  JMBVipController.m
//  密码生产器
//
//  Created by 张传奇 on 16/9/5.
//  Copyright © 2016年 张传奇. All rights reserved.
//http://www.cnblogs.com/gcb999/archive/2013/04/23/3038759.html

#import "JMBVipController.h"
NSString *const kSwitchCheck = @"switchCheck";
NSString *const kSelectorPush = @"selectorPush";

@interface JMBVipController()<XLFormOptionObject>

@end

@implementation JMBVipController

-(void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(SaveEnable:)];
//    barButton.possibleTitles = [NSSet setWithObjects:@"Disable", @"Enable", nil];
    self.navigationItem.rightBarButtonItem = barButton;
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeForm];
    }
    return self;
}

-(void)initializeForm
{
    
    NSArray * fileNsarray = [self loadFileManager];
    
    XLFormDescriptor * from = [XLFormDescriptor formDescriptorWithTitle:@"文件导入"];
    
    XLFormSectionDescriptor * section;
    section = [XLFormSectionDescriptor formSectionWithTitle:@"iTunes 内文件"];
//    section.footerTitle = @"OthersFormViewController.h";
    [from addFormSection:section];
    XLFormRowDescriptor * row;
    
    
    for (NSString * obj in fileNsarray) {
        [section addFormRow:[XLFormRowDescriptor formRowDescriptorWithTag:obj rowType:XLFormRowDescriptorTypeBooleanCheck title:obj]];
    }
    section = [XLFormSectionDescriptor formSectionWithTitle:@"文件处理"];
    section.footerTitle = @"OthersFormViewController.h";
    [from addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"查看移动后文件" rowType:XLFormRowDescriptorTypeButton title:@"查看移动后文件"];
    [row.cellConfigAtConfigure setObject:[UIColor purpleColor] forKey:@"backgroundColor"];
    [row.cellConfig setObject:[UIColor whiteColor] forKey:@"textLabel.color"];
    [row.cellConfig setObject:[UIFont fontWithName:@"Helvetica" size:20] forKey:@"textLabel.font"];
    [section addFormRow:row];
    row.action.formSelector = @selector(didTouchButton);
//    row.action.formSelector = @selector(didTouchButton:);
    self.form = from;
}
-(void)didTouchButton:(XLFormRowDescriptor *)sender
{
//   sender.value
    NSLog(@"%@",sender.value);
}
-(NSArray *)loadFileManager
{
    
    NSString * cachsting = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"%@",cachsting);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *folderContents =[fileManager contentsOfDirectoryAtPath:cachsting error:&error];

    
    return folderContents;
}


-(void)SaveEnable:(UIButton *)sender
{
    
    NSLog(@"%@",NSHomeDirectory() );
        NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * formsting = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * tostring =[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"movefile"];
 
    if ([fileManager createDirectoryAtPath:tostring withIntermediateDirectories:YES attributes:nil error:nil]) {
        
        NSLog(@"创建成功");
        
    }
    NSLog(@"%@",tostring);
    
    for (NSString *key in self.formValues) {
        NSLog(@"key: %@ value: %@", key, self.formValues[key]);
        if ([[self.formValues objectForKey:key] isEqual:[NSNull null]]) {
            continue;
        }
        if ( [self.formValues[key] integerValue] ==1) {
            [fileManager moveItemAtPath:[formsting stringByAppendingFormat:@"/%@", key] toPath:[tostring stringByAppendingFormat:@"/%@", key] error:nil];
        }
    }
    
    [self initializeForm];
}

-(void)didTouchButton
{
    NSString * cachsting = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"movefile"];
    NSLog(@"%@",cachsting);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *folderContents =[fileManager contentsOfDirectoryAtPath:cachsting error:&error];
    
    
    for (NSString * obj in folderContents) {
        NSLog(@"%@",obj);
    }
}
@end
