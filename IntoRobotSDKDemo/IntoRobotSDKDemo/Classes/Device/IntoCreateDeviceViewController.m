//
//  IntoCreateDeviceViewController.m
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/16.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import "IntoCreateDeviceViewController.h"
#import "IntoRobotSDK.h"
#import "MBProgressHUD+IntoRobot.h"

@interface IntoCreateDeviceViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *deviceNameText;
@property (weak, nonatomic) IBOutlet UITextField *curWiFiPWDText;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@end

@implementation IntoCreateDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"创建设备";
}

- (IBAction)createDevice:(UIButton *)sender {
    
    [MBProgressHUD showMessage:@"创建设备"];
    IntoWeakSelf;
    [IntoRobotSDKManager creatDeviceWithDeviceName:self.deviceNameText.text WiFiPwd:self.curWiFiPWDText.text successBlock:^(id responseObject) {
        
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showSuccess:@"创建成功"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        ! weakSelf.createSuccess ? : weakSelf.createSuccess();
    } errorBlock:^(NSString *errorStr) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:errorStr];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_deviceNameText.hasText && _curWiFiPWDText.hasText) {
        
        self.createButton.enabled = YES;
        
    }else{
        self.createButton.enabled = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self createDevice:nil];
    return YES;
}

@end
