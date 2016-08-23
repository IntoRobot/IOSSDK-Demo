//
//  IntoResetPWViewController.m
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/15.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import "IntoResetPWViewController.h"
#import "IntoRobotSDK.h"
#import "MBProgressHUD+IntoRobot.h"

// 账号类型
typedef  NS_ENUM(NSInteger, IntoResertPWType) {
    IntoResetPWTypePhone,      // 手机账号
    IntoResetPWTypeEmail,      // 邮箱账号
};

@interface IntoResetPWViewController ()
{
    int currentCounting;//当前计数
}

@property (weak, nonatomic) IBOutlet UITextField *PhoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (nonatomic, strong) NSTimer *timer;
/** 账号类型 */
@property (nonatomic,assign) IntoResertPWType accoutType;
@end

@implementation IntoResetPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)requestCodeToResetPW:(UIButton *)sender {
    
    /**
     *  获取验证码
     */
    
    IntoWeakSelf;
    if (!_PhoneNumTextField.hasText) {
        [MBProgressHUD showError:@"请输入邮箱号或者手机号"];
        return;
    } else if (![_PhoneNumTextField.text isMobileNumber] && [_PhoneNumTextField.text isValidateEmail]){ // 邮箱
        self.accoutType = IntoResetPWTypeEmail;
        [IntoRobotSDKManager ml_requestEmailCode_POST_WithEmail:self.PhoneNumTextField.text Progress:^(NSProgress *uploadProgress) {
            
        } successBlock:^(id responseObject) {
            
            [weakSelf codeGetSuccess];
            
        } errorBlock:^(NSString *errorStr) {
            [MBProgressHUD showError:errorStr];
        }];
        
    }else if ([_PhoneNumTextField.text isMobileNumber] && ![_PhoneNumTextField.text isValidateEmail]){ // 手机号
        self.accoutType = IntoResetPWTypePhone;
        [IntoRobotSDKManager ml_requestSMSCode_POST_WithPhone:self.PhoneNumTextField.text Zone:@"0086" Progress:^(NSProgress *uploadProgress) {
            
        } successBlock:^(id responseObject) {
            
            [weakSelf codeGetSuccess];
            
        } errorBlock:^(NSString *errorStr) {
            [MBProgressHUD showError:errorStr];
        }];
        
    }else{
        [MBProgressHUD showError:@"请输入正确邮箱号或者手机号"];
        return;
    }
}


-(void)codeGetSuccess
{
    currentCounting = 0;
    self.codeButton.enabled = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(resetCodeButtonTitle)
                                                userInfo:nil
                                                 repeats:YES];
}

-(void)resetCodeButtonTitle
{
    if (currentCounting == 60) {
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateDisabled];
        self.codeButton.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    self.sureButton.enabled = YES;
    [self.codeButton setTitle:[NSString stringWithFormat:@"%d秒后重发", 60 - currentCounting] forState:UIControlStateDisabled];
    currentCounting ++;
}

- (IBAction)commitButtonClick:(UIButton *)sender {
    IntoWeakSelf;
    if (self.accoutType == IntoResetPWTypePhone) { // 手机号
        [IntoRobotSDKManager ml_resetPW_PUT_WithPhone:self.PhoneNumTextField.text andPassword:self.passwordTextField.text vldCode:self.codeTextField.text SuccessBlock:^(id responseObject) {
            
            [MBProgressHUD showSuccess:@"修改成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } errorBlock:^(NSString *errorStr) {
            
            [MBProgressHUD showError:errorStr];
        }];
    }else if (self.accoutType == IntoResetPWTypeEmail){ // 邮箱
        [IntoRobotSDKManager ml_resetPW_PUT_WithEmail:self.PhoneNumTextField.text andPassword:self.passwordTextField.text vldCode:self.codeTextField.text SuccessBlock:^(id responseObject) {
            [MBProgressHUD showSuccess:@"修改成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } errorBlock:^(NSString *errorStr) {
            [MBProgressHUD showError:errorStr];
        }];
    }
}

@end
