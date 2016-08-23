//
//  IntoPersionTableViewController.m
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/16.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import "IntoPersionTableViewController.h"
#import "IntoRobotSDK.h"
#import "MBProgressHUD+IntoRobot.h"

@interface IntoPersionTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAccoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *userKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTokenLabel;
@property (weak, nonatomic) IBOutlet UILabel *createAtLabel;
/** 用户ID */
@property (nonatomic,copy) NSString *userId;
/** 修改输入框 */
@property (nonatomic,weak) UITextField *changeUserText;
@end

@implementation IntoPersionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsSelection = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userId = [defaults stringForKey:@"userId"];
    
    IntoWeakSelf;
    [IntoRobotSDKManager ml_requestUserInfo_GET_WithUserID:self.userId progress:^(NSProgress *downloadProgress) {
        
    } successBlock:^(id responseObject) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setUpViewWith:responseObject];
        });
    } errorBlock:^(NSString *errorStr) {
        
    }];
}

- (void)setUpViewWith:(NSDictionary *)responseObj{
    self.userNameLabel.text = responseObj[@"username"];
    self.userIdLabel.text = responseObj[@"userId"];
    if ([responseObj objectForKey:@"phone"]) {
        
        self.userAccoutLabel.text = responseObj[@"phone"];
    }else if ([responseObj objectForKey:@"email"]) {
        
        self.userAccoutLabel.text = responseObj[@"email"];
    }
    
    self.userKeyLabel.text = responseObj[@"userKey"];
    self.userTokenLabel.text = responseObj[@"token"];
    NSString *createTime = [NSString stringWithFormat:@"%@",responseObj[@"createdAt"]];
    self.createAtLabel.text = [createTime getDateTimeString];
}

/**
 *  退出登录
 */
- (IBAction)loginOut:(UIButton *)sender {
    
    IntoWeakSelf;
    [IntoRobotSDKManager ml_Logout_GET_WithUserID:self.userId progress:^(NSProgress *downloadProgress) {
        
    } successBlock:^(id responseObject) {
        
        [MBProgressHUD showSuccess:@"退出成功"];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        
    } errorBlock:^(NSString *errorStr) {
        [MBProgressHUD showError:errorStr];
    }];
}
/**
 *  修改用户名
 */
- (IBAction)chengeUserName:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改用户名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加按钮
    IntoWeakSelf;
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        NSString *newName = weakSelf.changeUserText.text;
        parameters[@"username"] = newName;
        [IntoRobotSDKManager ml_changeUserInfo_PUT_WithUserID:self.userId parameters:parameters successBlock:^(id responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
               weakSelf.userNameLabel.text = newName;
                [MBProgressHUD showSuccess:@"修改成功"];
            });
        } errorBlock:^(NSString *errorStr) {
            [MBProgressHUD showError:errorStr];
        }];
    }];
    [alertController addAction:sure];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    // 还可以添加文本框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.placeholder = @"请输入用户名";
        weakSelf.changeUserText = textField;
    }];
    
    // 在当前控制器上面弹出另一个控制器：alertController
    [self presentViewController:alertController animated:YES completion:nil];

}

@end
