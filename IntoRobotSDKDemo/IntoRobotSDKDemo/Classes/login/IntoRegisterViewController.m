//
//  IntoRegisterViewController.m
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/15.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import "IntoRegisterViewController.h"
#import "IntoRobotSDK.h"
#import "MBProgressHUD+IntoRobot.h"

// 注册类型
typedef  NS_ENUM(NSInteger, IntoRegisterType) {
    IntoRegisterTypePhone,      // 手机注册
    IntoRegisterTypeEmail,      // 邮箱注册
};

@interface IntoRegisterViewController()
{
    int currentCounting;//当前计数
}

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
/** 邮箱注册或者手机注册 */
@property (nonatomic,assign) IntoRegisterType registerType;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation IntoRegisterViewController

/**
 *  获取验证码
 */
- (IBAction)getCode:(UIButton *)sender {
    
    IntoWeakSelf;
    if (!_usernameTextField.hasText) {
        [MBProgressHUD showError:@"请输入用户名"];
        return;
    }else if (!_phoneNumTextField.hasText) {
        [MBProgressHUD showError:@"请输入邮箱号或者手机号"];
        return;
    } else if (![_phoneNumTextField.text isMobileNumber] && [_phoneNumTextField.text isValidateEmail]){ // 邮箱
        self.registerType = IntoRegisterTypeEmail;
        [IntoRobotSDKManager ml_requestEmailCode_POST_WithEmail:self.phoneNumTextField.text Progress:^(NSProgress *uploadProgress) {
            
        } successBlock:^(id responseObject) {
            
            [weakSelf codeGetSuccess];
            
        } errorBlock:^(NSString *errorStr) {
            [MBProgressHUD showError:errorStr];
        }];
     
    }else if ([_phoneNumTextField.text isMobileNumber] && ![_phoneNumTextField.text isValidateEmail]){ // 手机号
        self.registerType = IntoRegisterTypePhone;
        [IntoRobotSDKManager ml_requestSMSCode_POST_WithPhone:self.phoneNumTextField.text Zone:@"0086" Progress:^(NSProgress *uploadProgress) {
            
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
    self.registerButton.enabled = YES;
    [self.codeButton setTitle:[NSString stringWithFormat:@"%d秒后重发", 60 - currentCounting] forState:UIControlStateDisabled];
    currentCounting ++;
}

// 提交
- (IBAction)commitData:(UIButton *)sender{
    IntoWeakSelf;
    
    if (self.registerType == IntoRegisterTypePhone) {

        [IntoRobotSDKManager ml_registerUser_POST_WithPhone:self.phoneNumTextField.text username:self.usernameTextField.text password:self.passwordTextField.text vldCode:self.codeTextField.text Progress:^(NSProgress *uploadProgress) {
            
        } successBlock:^(id responseObject) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:@"注册成功"];
        } errorBlock:^(NSString *errorStr) {
            [MBProgressHUD showError:errorStr];
        }];
        
    }else if (self.registerType == IntoRegisterTypeEmail){
        [IntoRobotSDKManager ml_registerUser_POST_WithEmail:self.phoneNumTextField.text username:self.usernameTextField.text password:self.passwordTextField.text vldCode:self.codeTextField.text Progress:^(NSProgress *uploadProgress) {
            
        } successBlock:^(id responseObject) {

            [weakSelf.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:@"注册成功"];
        } errorBlock:^(NSString *errorStr) {
            [MBProgressHUD showError:errorStr];
        }];
    }
}

@end
