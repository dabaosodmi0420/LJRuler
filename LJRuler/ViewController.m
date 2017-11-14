//
//  ViewController.m
//  LJRuler
//
//  Created by Apple on 2017/10/13.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "ViewController.h"
#import "LJRulerView.h"
@interface ViewController ()<LJRulerViewDlegate,UITextFieldDelegate>
/** <# explain #> */
@property (nonatomic, strong) LJRulerView *rv;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _rv = [[LJRulerView alloc]initWithFrame:CGRectMake(20, 60, 300, 60) perScale:10 maxScale:3500];
    _rv.delegate = self;
    [self.view addSubview:_rv];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 140, 300, 30)];
    textField.placeholder = @"placeHolder";
    textField.textAlignment = NSTextAlignmentCenter;
//    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.delegate = self;
    [self.view addSubview:textField];
    
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view resignFirstResponder];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *text = textField.text;
    CGFloat value = [text doubleValue];
    [_rv lj_setValue:value];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)lj_rulerViewGetCurrentValue:(CGFloat)value{
    NSLog(@"当前值--%f",value);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
