//
//  IntoDeviceInfoTableViewController.m
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/16.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import "IntoDeviceInfoTableViewController.h"
#import "IntoRobotSDK.h"
#import "MBProgressHUD+IntoRobot.h"

@interface IntoDeviceInfoTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *productIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *bindAtLabel;
/** 设备名称输入 */
@property (nonatomic,weak) UITextField *nameTextField;
/** 设备名称输入 */
@property (nonatomic,weak) UITextField *descriptionTextField;
@end

@implementation IntoDeviceInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.deviceNameLabel.text = self.deviceDic[@"name"];
    self.deviceDescriptionLabel.text = self.deviceDic[@"description"];
    self.deviceIdLabel.text = self.deviceDic[@"deviceId"];
    self.productIdLabel.text = self.deviceDic[@"productId"];
    NSString *createTime = [NSString stringWithFormat:@"%@",self.deviceDic[@"bindAt"]];
    self.bindAtLabel.text = [createTime getDateTimeString];
    if ([self.deviceDic[@"locked"] isEqual:@1]) {
//        IntoLog(@"锁定");
    }else{
//        IntoLog(@"未锁定");
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            IntoWeakSelf;
            UIAlertController *alertController = [self alertControlWithTitle:@"修改设备名称" sureActionHandle:^(UIAlertAction *sureAction) {
                NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
                NSString *newName = weakSelf.nameTextField.text;
                parameter[@"name"] = newName;
                [IntoRobotSDKManager ml_changeDeviceInfo_PUT_WithDeviceId:weakSelf.deviceDic[@"deviceId"] parameters:parameter successBlock:^(id responseObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        weakSelf.deviceNameLabel.text = newName;
                        ! weakSelf.changeSuccess ? :weakSelf.changeSuccess();
                    });
                } errorBlock:^(NSString *errorStr) {
                    
                    [MBProgressHUD showError:errorStr];
                }];
            } cancelActionHandle:^(UIAlertAction *cancelAction) {
                
            } configHandle:^(UITextField *textField) {
                textField.placeholder = @"请输入用户名";
                textField.text = weakSelf.deviceNameLabel.text;
                weakSelf.nameTextField = textField;
            }];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
        case 1:
        {
            IntoWeakSelf;
            UIAlertController *alertController = [self alertControlWithTitle:@"修改设备描述" sureActionHandle:^(UIAlertAction *sureAction) {
                NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
                NSString *newDescription = weakSelf.descriptionTextField.text;
                parameter[@"description"] = newDescription;
                [IntoRobotSDKManager ml_changeDeviceInfo_PUT_WithDeviceId:weakSelf.deviceDic[@"deviceId"] parameters:parameter successBlock:^(id responseObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        weakSelf.deviceDescriptionLabel.text = newDescription;
                        ! weakSelf.changeSuccess ? :weakSelf.changeSuccess();
                    });
                } errorBlock:^(NSString *errorStr) {
                    
                    [MBProgressHUD showError:errorStr];
                }];
            } cancelActionHandle:^(UIAlertAction *cancelAction) {
                
            } configHandle:^(UITextField *textField) {
                textField.placeholder = @"请输入用户名";
                textField.text = weakSelf.deviceDescriptionLabel.text;
                weakSelf.descriptionTextField = textField;
            }];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    
}

/**
 *  修改信息的弹窗
 *
 *  @param title        标题
 *  @param sureHandle   确定按钮点击回调
 *  @param cancelHandle 取消按钮点击回调
 *  @param configHandle 文本框输入
 */
- (UIAlertController *)alertControlWithTitle:(NSString *)title sureActionHandle:(void(^)(UIAlertAction *sureAction))sureHandle cancelActionHandle:(void(^)(UIAlertAction *cancelAction))cancelHandle configHandle:(void(^)(UITextField *textField))configHandle{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:sureHandle];
    [alertController addAction:sureAction];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancelHandle]];
    [alertController addTextFieldWithConfigurationHandler:configHandle];
    return alertController;
}

@end
