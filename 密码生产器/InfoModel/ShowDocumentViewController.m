//
//  ShowDocumentViewController.m
//  密码生产器
//
//  Created by legend on 2017/4/1.
//  Copyright © 2017年 张传奇. All rights reserved.
//

#import "ShowDocumentViewController.h"
#import <QuickLook/QuickLook.h>
@interface ShowDocumentViewController ()<QLPreviewControllerDelegate,QLPreviewControllerDataSource>
{
    NSString * titlename;
}
@end

@implementation ShowDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeForm];
}

-(void)initializeForm
{
    
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptor];
    section = [XLFormSectionDescriptor formSectionWithTitle:@"存储模板"];
    [form addFormSection:section];
    
    NSArray * temparray = [self loadFileManager];
    
    for (NSString * obj in temparray) {
    row = [XLFormRowDescriptor formRowDescriptorWithTag:obj rowType:XLFormRowDescriptorTypeButton title:obj];
       [row.cellConfig setObject:@(NSTextAlignmentNatural) forKey:@"textLabel.textAlignment"];
        row.action.formSelector = @selector(selectRow:);
        [section addFormRow:row];
    }
    

    
    
    self.form = form;
}

-(NSArray *)loadFileManager
{
    
    NSString * cachsting = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"movefile"];
    NSLog(@"%@",cachsting);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *folderContents =[fileManager contentsOfDirectoryAtPath:cachsting error:&error];
    
    
    return folderContents;
}

-(void)selectRow:(XLFormRowDescriptor *)sender
{
//    if ([[sender.sectionDescriptor.formDescriptor formRowWithTag:kSwitchBool].value
//    sender.value
  
    titlename =  sender.title;
    
    
    QLPreviewController *myQlPreViewController = [[QLPreviewController alloc]init];
    myQlPreViewController.delegate =self;
    myQlPreViewController.dataSource =self;
    [myQlPreViewController setCurrentPreviewItemIndex:0];
    [self presentViewController:myQlPreViewController animated:YES completion:nil];
    
}
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    NSString * cachsting = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"movefile"];
    cachsting = [cachsting stringByAppendingPathComponent:titlename];
    NSLog(@"%@",cachsting);
    

    return [NSURL fileURLWithPath:cachsting];
    
}
@end
