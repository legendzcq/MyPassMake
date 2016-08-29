//
//  JMBPassMakeViewController.m
//  密码生产器
//
//  Created by 张传奇 on 16/8/29.
//  Copyright © 2016年 张传奇. All rights reserved.
//

#import "JMBPassMakeViewController.h"
#import "JMBPassMakeView.h"
#import "JMBPass.h"
@interface JMBPassMakeViewController()
{
    __block int lengthValue;
    __block int NumValue;
    __block int signValue;
    __block BOOL isLoweValue;
    __block BOOL IsReplaceValue;
}
@property(nonatomic,strong)JMBPassMakeView * jmbView;
@end

@implementation JMBPassMakeViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    
   
    self.navigationItem.title = @"生成密码";
    
        [self setupView];
}

- (void)setupView {
  
    JMBPassMakeView * jmbView = [[JMBPassMakeView alloc] initWithFrame:(CGRect){0, 0, self.view.bounds.size}];
    
    self.jmbView = jmbView;
    
    [self.view addSubview:jmbView];
    
    [jmbView setlengthcontAction:^(int Lvalue, int Nvalue, int Svalue, BOOL isLowe, BOOL IsReplace) {
        lengthValue=Lvalue;
        NumValue = Nvalue;
        signValue = Svalue;
        isLoweValue = isLowe;
        IsReplaceValue = IsReplace;
     jmbView.passCont.text = [JMBPass passMakeLenth:Lvalue isNum:Nvalue singleNum:Svalue isLow:isLowe isReplace:IsReplace];
    }];
    [jmbView setCopyBtnAction:^{
        NSLog(@"adfadfas");
    }];
    [jmbView setMakeBtnAction:^{
     jmbView.passCont.text = [JMBPass passMakeLenth:lengthValue isNum:NumValue singleNum:signValue isLow:isLoweValue isReplace:IsReplaceValue];
    }];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.jmbView.lengthNum.text = @"sdafas";
}


@end
