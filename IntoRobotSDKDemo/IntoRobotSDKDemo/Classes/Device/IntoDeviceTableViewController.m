//
//  IntoDeviceTableViewController.m
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/15.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import "IntoDeviceTableViewController.h"
#import "IntoRobotSDK.h"
#import "DTKDropdownMenuView.h"
#import "IntoCreateDeviceViewController.h"
#import "IntoDeviceInfoTableViewController.h"
#import "IntoDeviceTableViewCell.h"
#import "IntoRobotMQTTManager.h"
#import "IntoDeviceModel.h"
#import "IntoContrlDeviceViewController.h"
#import "MBProgressHUD+IntoRobot.h"

@interface IntoDeviceTableViewController ()<IntoRobotMQTTManagerDelegate>
/** 设备数组 */
@property (nonatomic,strong) NSMutableArray *deviceArray;
/** 选中的设备数数据 */
@property (nonatomic,strong) NSDictionary *selectDeviceDic;
@end

@implementation IntoDeviceTableViewController

- (NSMutableArray *)deviceArray
{
    if (!_deviceArray) {
        _deviceArray = [NSMutableArray array];
    }
    return _deviceArray;
}

- (void)setNavigation{
    IntoWeakSelf;
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"添加设备" iconName:nil callBack:^(NSUInteger index, id info) {
        IntoCreateDeviceViewController *createDeviceVC = [[IntoCreateDeviceViewController alloc] init];
        createDeviceVC.createSuccess = ^{
            
            [weakSelf loadDeviceData];
        };
        [weakSelf.navigationController pushViewController:createDeviceVC animated:YES];
    }];
    
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 44.f, 44.f) dropdownItems:@[item0] icon:@"deviceMore"];
    menuView.dropWidth = 130.f;
    menuView.textColor = [UIColor blackColor];
    menuView.cellSeparatorColor = [UIColor grayColor];
    menuView.textFont = [UIFont systemFontOfSize:14.f];
    menuView.animationDuration = 0.2f;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设备列表";
    [self setNavigation];
    self.tableView.tableFooterView = [[UIView alloc] init];
    // 加载数据
    [self loadDeviceData];
    
}

// 请求数据
- (void)loadDeviceData{
    IntoWeakSelf;
    [IntoRobotSDKManager ml_requestUserDeviceList_GET_Progress:^(NSProgress *downloadProgress) {
        
    } successBlock:^(id responseObject) {
        weakSelf.deviceArray = [IntoDeviceModel mj_objectArrayWithKeyValuesArray:responseObject];
        [weakSelf.tableView reloadData];
        
        // 订阅 topic
        [weakSelf mqttConnectSubMes];
        
    } errorBlock:^(NSString *errorStr) {
        [MBProgressHUD showError:errorStr];
    }];
}

// 订阅
- (void)mqttConnectSubMes
{
    IntoRobotMQTTManager *mqttManager = [IntoRobotMQTTManager shareIntoRobotMQTTManager];
    mqttManager.ml_MQTTDelegate = self;
    [mqttManager ml_MqttConnectWithUser:self.userData[@"token"] pass:self.userData[@"userId"] connectHandle:^(int handEnumValue) {
        
    }];
    
    // 其中一种方法
    for (IntoDeviceModel *device in self.deviceArray) {
        [mqttManager ml_SubDeviceOnlineStatusWithDeviceId:device.deviceId SubHandle:^(NSDictionary *subscriptions) {}];
    }
//    // 另一种方法
//    NSMutableDictionary *subDic = [NSMutableDictionary dictionary];
//    for (IntoDeviceModel *device in self.deviceArray) {
//        NSString *topic = [NSString stringWithFormat:@"v1/%@/platform/default/info/online",device.deviceId];
//        subDic[topic] = @(MQTTQosLevelAtMostOnce);
//    }
//    [mqttManager ml_SubScribeTopics:subDic SubHandle:^(NSDictionary *subscriptions) {
//        // 订阅的Topic
//        IntoLog(@"%@",subscriptions);
//    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IntoDeviceTableViewCell *cell = [IntoDeviceTableViewCell cellWithTable:tableView Style:UITableViewCellStyleSubtitle reuseIdentifier:@"deviceCell"];
    cell.deviceModel = self.deviceArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    IntoDeviceModel *deviceModel = self.deviceArray[indexPath.row];
    self.selectDeviceDic = [deviceModel mj_keyValuesWithIgnoredKeys:@[@"online"]];
    [self performSegueWithIdentifier:@"controlDevice" sender:nil];
}

/**
 *   跳转之前的准备
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"deviceInfo"]) {
        IntoWeakSelf;
        IntoDeviceInfoTableViewController *deviceInfoVC = segue.destinationViewController;
        deviceInfoVC.deviceDic = self.selectDeviceDic;
        deviceInfoVC.changeSuccess = ^{
            [weakSelf loadDeviceData];
        };
    }else if ([segue.identifier isEqualToString:@"controlDevice"]) {
        IntoContrlDeviceViewController *controlDeviceVC = segue.destinationViewController;
        controlDeviceVC.deviceId = self.selectDeviceDic[@"deviceId"];
        controlDeviceVC.userData = self.userData;
    }
}
/**
 *  删除
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IntoDeviceModel *deviceModel = self.deviceArray[indexPath.row];
    IntoWeakSelf;
    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        IntoDeviceModel *deviceModel = self.deviceArray[indexPath.row];
        self.selectDeviceDic = [deviceModel mj_keyValuesWithIgnoredKeys:@[@"online"]];
        [self performSegueWithIdentifier:@"deviceInfo" sender:nil];
    }];
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [IntoRobotSDKManager ml_deleteDevice_DELETE_WithDeviceId:deviceModel.deviceId successBlock:^(id responseObject) {
            
            [weakSelf.deviceArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [MBProgressHUD showSuccess:@"删除成功"];
        } errorBlock:^(NSString *errorStr) {
            [MBProgressHUD showError:errorStr];
        }];
    }];
    
    return @[action1, action0];
}

// 要等一段时间才会改变在线状态( 3-5 Min)
- (void)ml_HandleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained{
    // 收到的数据
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dataDic = [dataString dictionaryValue];
    // topic
    NSArray *topicArray = [topic componentsSeparatedByString:@"/"];
    NSString *topicDeviceID = topicArray[1];
    for (IntoDeviceModel *device in self.deviceArray) {
        
        if ([device.deviceId isEqualToString:topicDeviceID]) {
            if ([dataDic[@"key"] isEqualToString:@"online"]) {
                device.online = YES;
            }else if ([dataDic[@"key"] isEqualToString:@"offline"]) {
                device.online = NO;
            }
            [self.tableView reloadData];
            break;
        }
    }
}
@end
