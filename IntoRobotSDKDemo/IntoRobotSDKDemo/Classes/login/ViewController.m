//
//  ViewController.m
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/12.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import "ViewController.h"
#import "IntoRobotSDK.h"
#import "IntoDeviceTableViewController.h"
#import "IntoRegisterViewController.h"
#import "MBProgressHUD+IntoRobot.h"

@interface ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
/** 用户模型 */
@property (nonatomic,strong) NSDictionary *userData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_emailText.hasText && _passwordText.hasText) {
        
        self.loginButton.enabled = YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)loginButton:(UIButton *)sender {
    IntoWeakSelf;
    if (![_emailText.text isMobileNumber] && [_emailText.text isValidateEmail]){ // 邮箱
        [MBProgressHUD showMessage:@"正在登录"];
        [IntoRobotSDKManager ml_Login_POST_WithEmail:self.emailText.text andPassword:self.passwordText.text progress:^(NSProgress *uploadProgress) {
            
        } successBlock:^(id responseObject) {
            weakSelf.userData = responseObject;
            [MBProgressHUD hideHUD];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:responseObject[@"userId"] forKey:@"userId"];
            
            [weakSelf performSegueWithIdentifier:@"loginToDevice" sender:nil];
            
        } errorBlock:^(NSString *errorStr) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:errorStr];
        }];

    }else if ([_emailText.text isMobileNumber] && ![_emailText.text isValidateEmail]){ // 手机号
        [MBProgressHUD showMessage:@"正在登录"];
        [IntoRobotSDKManager ml_Login_POST_WithPhone:self.emailText.text andPassword:self.passwordText.text progress:^(NSProgress *uploadProgress) {
            
        } successBlock:^(id responseObject) {
            weakSelf.userData = responseObject;
            [MBProgressHUD hideHUD];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:responseObject[@"userId"] forKey:@"userId"];
            
            [weakSelf performSegueWithIdentifier:@"loginToDevice" sender:nil];
            
        } errorBlock:^(NSString *errorStr) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:errorStr];
        }];
        
    }else{
        [MBProgressHUD showError:@"请输入正确邮箱号或者手机号"];
        return;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"loginToDevice"]) {
        
        IntoDeviceTableViewController *deviceVC = segue.destinationViewController;
        deviceVC.userData = self.userData;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_emailText.hasText && _passwordText.hasText) {
        
        self.loginButton.enabled = YES;
    }else{
        self.loginButton.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self loginButton:nil];
    return YES;
}
@end
