//
//  JMBPassMakeView.m
//  密码生产器
//
//  Created by 张传奇 on 16/8/29.
//  Copyright © 2016年 张传奇. All rights reserved.
//

#import "JMBPassMakeView.h"
#import "Masonry.h"
#define MAXLENGTH 50
#define MAXNUM 10
@interface JMBPassMakeView()
{
    __block int lengthValue;
    __block int NumValue;
    __block int signValue;
    __block BOOL isLowe;
    __block BOOL IsReplace;
    BOOL secureIsSelect;
}

@property(nonatomic,weak)UISlider * lengthcont;
@property(nonatomic,weak)UISlider * Numcont;
@property(nonatomic,weak)UILabel * NumNum;
@property(nonatomic,weak)UISlider * signcont;
@property(nonatomic,weak)UILabel * signNum;
@property(nonatomic,weak)UISwitch * Lowercase;
@property(nonatomic,weak)UISwitch * repeat;
@property(nonatomic,weak)UIButton * showPass;

@property(nonatomic,weak)UIButton * AcopyBtn;
@property(nonatomic,weak)UIButton * makePassBtn;
@property (nonatomic, copy) JMBPassMakeViewNeedReloadBlock lengthcontBlock;
@property (nonatomic, copy) JMBPassMakeViewBtnReloadBlock copyBtnBlock;
@property (nonatomic, copy) JMBPassMakeViewBtnReloadBlock makeBtnBlock;
@end

@implementation JMBPassMakeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commView];
    }
    return self;
}
-(void)commView
{
  self.backgroundColor = [UIColor whiteColor];
    //长度
    UILabel * lengthName = [[UILabel alloc]init];
    lengthName.text = @"长度";
    [self addSubview:lengthName];
    [lengthName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(100);
        make.left.equalTo(self.mas_left).offset(20);
    }];
    
    UISlider * lengthcont = [UISlider new];
    lengthcont.minimumValue=0;
    lengthcont.maximumValue=MAXLENGTH;
    lengthcont.value = MAXLENGTH*0.5;
    [lengthcont addTarget:self action:@selector(updatelengthcontValue:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:lengthcont];
    [lengthcont mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lengthName.mas_centerY);
        make.left.equalTo(lengthName.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 10));
    }];
    self.lengthcont = lengthcont;
    UILabel * lengthNum = [[UILabel alloc]init];
    lengthNum.text = @"25/50";
    [self addSubview:lengthNum];
    [lengthNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lengthName.mas_centerY);
        make.left.equalTo(lengthcont.mas_right).offset(10);
    }];
    self.lengthNum = lengthNum;
    
    
    //数字
    UILabel * NumName = [[UILabel alloc]init];
    NumName.text = @"数字";
    [self addSubview:NumName];
    [NumName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lengthName.mas_bottom).offset(40);
        make.left.equalTo(lengthName.mas_left);
    }];
    
    UISlider * Numcont = [UISlider new];
    Numcont.minimumValue=0;
    Numcont.maximumValue=MAXNUM;
    Numcont.value = MAXNUM*0.5;
    [Numcont addTarget:self action:@selector(updateNumcontValue:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:Numcont];
    [Numcont mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(NumName.mas_centerY);
        make.left.equalTo(NumName.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 10));
    }];
    self.Numcont = Numcont;
    UILabel * NumNum = [[UILabel alloc]init];
    NumNum.text = @"4/10";
    [self addSubview:NumNum];
    [NumNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(NumName.mas_centerY);
        make.left.equalTo(Numcont.mas_right).offset(10);
    }];
    self.NumNum  = NumNum;
    
    //符号
    UILabel * signName = [[UILabel alloc]init];
    signName.text = @"符号";
    [self addSubview:signName];
    [signName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NumName.mas_bottom).offset(40);
        make.left.equalTo(lengthName.mas_left);
    }];
    UISlider * signcont = [UISlider new];
    signcont.minimumValue=0;
    signcont.maximumValue=MAXNUM;
    signcont.value = MAXNUM*0.5;
    [signcont addTarget:self action:@selector(updatesignValue:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:signcont];
    [signcont mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(signName.mas_centerY);
        make.left.equalTo(signName.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 10));
    }];
    self.signcont = signcont;
    UILabel * signNum = [[UILabel alloc]init];
    signNum.text = @"4/10";
    [self addSubview:signNum];
    [signNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(signName.mas_centerY);
        make.left.equalTo(signcont.mas_right).offset(10);
    }];
    self.signNum = signNum;
    //选择小写字母
    UISwitch * Lowercase = [UISwitch new];
    [Lowercase addTarget:self action:@selector(updateLowerValue:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:Lowercase];
    [Lowercase mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(signName.mas_bottom).offset(20);
        make.left.equalTo(self.mas_left).offset(40);
    }];
    self.Lowercase = Lowercase;
    UILabel * LowercaseName = [[UILabel alloc]init];
    LowercaseName.text = @"只使用小写字母";
    [self addSubview:LowercaseName];
    [LowercaseName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(Lowercase.mas_centerY);
        make.left.equalTo(Lowercase.mas_right).offset(5);
    }];
    //允许重复使用
    UISwitch * repeat = [UISwitch new];
   [repeat addTarget:self action:@selector(updaterepeatrValue:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:repeat];
    [repeat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Lowercase.mas_bottom).offset(20);
        make.left.equalTo(self.mas_left).offset(40);
    }];
    self.repeat = repeat;
    UILabel * repeatName = [[UILabel alloc]init];
    repeatName.text = @"允许重复使用同一字符";
    [self addSubview:repeatName];
    [repeatName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(repeat.mas_centerY);
        make.left.equalTo(repeat.mas_right).offset(5);
    }];
    
    //密码显示
    UIView * passView = [UIView new];
    passView.layer.borderWidth = 1;
    passView.layer.borderColor = [[UIColor grayColor] CGColor];
    [self addSubview:passView];
    [passView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(repeat.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(300, 40));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UIButton * showPass = [UIButton new];
    showPass.backgroundColor = [UIColor redColor];
    [showPass addTarget:self action:@selector(showPassClick:) forControlEvents:UIControlEventTouchUpInside];
    [passView addSubview:showPass];
    [showPass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passView.mas_top);
        make.right.equalTo(passView.mas_right);
        make.bottom.equalTo(passView.mas_bottom);
        make.width.mas_equalTo(@40);
    }];
    self.showPass = showPass;
    UITextField * passCont = [UITextField new];
    passCont.enabled = NO;
    secureIsSelect = NO;
      passCont.secureTextEntry = secureIsSelect;
    [passView addSubview:passCont];
    [passCont mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passView.mas_centerY);
        make.left.equalTo(passView.mas_left).offset(2);
        make.right.equalTo(showPass.mas_left);
    }];
    self.passCont = passCont;
    
    //复制剪切板
    UIButton * AcopyBtn = [UIButton new];
    AcopyBtn.layer.cornerRadius=5;
    [AcopyBtn setTitle:@"复制到剪切板" forState:UIControlStateNormal];
    AcopyBtn.backgroundColor = [UIColor grayColor];
    [AcopyBtn addTarget:self action:@selector(AcopyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:AcopyBtn];
    [AcopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 35));
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(passView.mas_bottom).offset(20);
    }];
    self.AcopyBtn = AcopyBtn;
    //生成密码
    UIButton * makePassBtn = [UIButton new];
    makePassBtn.layer.cornerRadius=5;
    [makePassBtn setTitle:@"生成密码" forState:UIControlStateNormal];
    makePassBtn.backgroundColor = [UIColor blueColor];
    [makePassBtn addTarget:self action:@selector(makePassBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:makePassBtn];
    [makePassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 35));
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(AcopyBtn.mas_bottom).offset(20);
    }];
    self.makePassBtn = makePassBtn;
    
    lengthValue = 25;
    NumValue = 4;
    signValue = 4;
    isLowe=NO;
    IsReplace=YES;
    [self.Lowercase setOn:NO];
    [self.repeat setOn:YES];
    
}
-(void)updatelengthcontValue:(UISlider *)paramSender
{
    int f = paramSender.value;
    self.lengthNum.text = [NSString stringWithFormat:@"%d/%d",f,MAXLENGTH];
    lengthValue = f;
    isLowe = self.Lowercase.isOn;
    IsReplace = self.repeat.isOn;
    if (_lengthcontBlock) {
        _lengthcontBlock(lengthValue,NumValue,signValue,isLowe,IsReplace);
    }
}
-(void)updateNumcontValue:(UISlider *)paramSender
{
    int f = paramSender.value;
    self.NumNum.text = [NSString stringWithFormat:@"%d/%d",f,MAXNUM];
    NumValue = f;
    isLowe = self.Lowercase.isOn;
    IsReplace = self.repeat.isOn;
    if (_lengthcontBlock) {
        _lengthcontBlock(lengthValue,NumValue,signValue,isLowe,IsReplace);
    }
}

-(void)updatesignValue:(UISlider *)paramSender
{
    int f = paramSender.value;
    self.signNum.text = [NSString stringWithFormat:@"%d/%d",f,MAXNUM];
    signValue = f;
    isLowe = self.Lowercase.isOn;
    IsReplace = self.repeat.isOn;
    if (_lengthcontBlock) {
        _lengthcontBlock(lengthValue,NumValue,signValue,isLowe,IsReplace);
    }
}


-(void)updateLowerValue:(UISwitch *)paramSender
{
    isLowe = paramSender.isOn;
    IsReplace = self.repeat.isOn;
    if (_lengthcontBlock) {
        _lengthcontBlock(lengthValue,NumValue,signValue,isLowe,IsReplace);
    }
}

-(void)updaterepeatrValue:(UISwitch *)paramSender
{
    isLowe = self.Lowercase.isOn;
    IsReplace = paramSender.isOn;
    if (_lengthcontBlock) {
        _lengthcontBlock(lengthValue,NumValue,signValue,isLowe,IsReplace);
    }
}
-(void)setlengthcontAction:(JMBPassMakeViewNeedReloadBlock)lengthcontBlock
{
    _lengthcontBlock = lengthcontBlock;
}
-(void)setCopyBtnAction:(JMBPassMakeViewBtnReloadBlock)copyBlock
{
    _copyBtnBlock = copyBlock;
}
-(void)setMakeBtnAction:(JMBPassMakeViewBtnReloadBlock)makeBlock
{
    _makeBtnBlock = makeBlock;
}
-(void)makePassBtnClick:(UIButton *)send
{
    if (_makeBtnBlock) {
        _makeBtnBlock();
    }
}
-(void)AcopyBtnClick:(UIButton *)send
{
    if (_copyBtnBlock) {
        _copyBtnBlock();
    }
}
-(void)showPassClick:(UIButton *)send
{
    
    self.passCont.secureTextEntry = !secureIsSelect;
    secureIsSelect =!secureIsSelect;
    
}

@end
