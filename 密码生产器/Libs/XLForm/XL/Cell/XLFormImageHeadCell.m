//
//  XLFormImageHeadCell.m
//  Pods
//
//  Created by 张传奇 on 16/9/5.
//
//

#import "XLFormImageHeadCell.h"
@interface XLFormImageHeadCell() <UITextFieldDelegate>

@property NSMutableArray * dynamicCustomConstraints;

@end
@implementation XLFormImageHeadCell

@synthesize returnKeyType = _returnKeyType;
@synthesize nextReturnKeyType = _nextReturnKeyType;


#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ((object == self.textLabel && [keyPath isEqualToString:@"text"]) ||  (object == self.imageView && [keyPath isEqualToString:@"image"])){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
            [self.contentView setNeedsUpdateConstraints];
        }
    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _returnKeyType = UIReturnKeyDefault;
        _nextReturnKeyType = UIReturnKeyNext;
        
    }
    return self;
}

-(void)dealloc
{
    [self.textLabel removeObserver:self forKeyPath:@"text"];
    [self.IconImage removeObserver:self forKeyPath:@"image"];
}


#pragma mark - XLFormDescriptorCell

-(void)configure
{
    [super configure];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self initUI];
    [self.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    [self.IconImage addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

-(void)initUI
{
    UIImageView * iconImage = [[UIImageView alloc]init];
    self.IconImage = iconImage;
    [self.contentView addSubview:self.IconImage];
    _IconImage.frame = CGRectMake(30, 15, 50, 50);
    
    UITextField * textfield = [[UITextField alloc]initWithFrame:CGRectMake(85, 15, 200,30)];
    self.textField = textfield;
    [self.contentView addSubview:self.textField];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(85, 46, 200, 0.8)];
    lineView.backgroundColor= [UIColor grayColor];
    [self.contentView addSubview:lineView];
    
}
#pragma mark - Helper

- (void)textFieldDidChange:(UITextField *)textField{
    if([self.textField.text length] > 0) {
        BOOL didUseFormatter = NO;
        
        if (self.rowDescriptor.valueFormatter && self.rowDescriptor.useValueFormatterDuringInput)
        {
            // use generic getObjectValue:forString:errorDescription and stringForObjectValue
            NSString *errorDescription = nil;
            NSString *objectValue = nil;
            
            if ([ self.rowDescriptor.valueFormatter getObjectValue:&objectValue forString:textField.text errorDescription:&errorDescription]) {
                NSString *formattedValue = [self.rowDescriptor.valueFormatter stringForObjectValue:objectValue];
                
                self.rowDescriptor.value = objectValue;
                textField.text = formattedValue;
                didUseFormatter = YES;
            }
        }
        
        // only do this conversion if we didn't use the formatter
        if (!didUseFormatter)
        {
            if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeNumber] || [self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeDecimal]){
                self.rowDescriptor.value =  [NSDecimalNumber decimalNumberWithString: self.textField.text];
            } else if ([self.rowDescriptor.rowType isEqualToString:XLFormRowDescriptorTypeInteger]){
                self.rowDescriptor.value = @([self.textField.text integerValue]);
            } else {
                self.rowDescriptor.value = self.textField.text;
            }
        }
    } else {
        self.rowDescriptor.value = nil;
    }
}


+ (CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor
{
    return 80;
}

-(BOOL)formDescriptorCellCanBecomeFirstResponder
{
    return (!self.rowDescriptor.isDisabled);
}

-(BOOL)formDescriptorCellBecomeFirstResponder
{
    return [self.textField becomeFirstResponder];
}
-(void)highlight
{
    [super highlight];
    self.textLabel.textColor = self.tintColor;
}

-(void)unhighlight
{
    [super unhighlight];
    [self.formViewController updateFormRow:self.rowDescriptor];
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return [self.formViewController textFieldShouldClear:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self.formViewController textFieldShouldReturn:textField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return [self.formViewController textFieldShouldBeginEditing:textField];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return [self.formViewController textFieldShouldEndEditing:textField];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self.formViewController textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.formViewController beginEditing:self.rowDescriptor];
    [self.formViewController textFieldDidBeginEditing:textField];
    // set the input to the raw value if we have a formatter and it shouldn't be used during input
    if (self.rowDescriptor.valueFormatter) {
        self.textField.text = [self.rowDescriptor editTextValue];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // process text change before we stick a formatted value in the UITextField
    [self textFieldDidChange:textField];
    
    // losing input, replace the text field with the formatted value
    if (self.rowDescriptor.valueFormatter) {
        self.textField.text = [self.rowDescriptor.value displayText];
    }
    
    [self.formViewController endEditing:self.rowDescriptor];
    [self.formViewController textFieldDidEndEditing:textField];
}
-(void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    _returnKeyType = returnKeyType;
    self.textField.returnKeyType = returnKeyType;
}

-(UIReturnKeyType)returnKeyType
{
    return _returnKeyType;
}
@end
