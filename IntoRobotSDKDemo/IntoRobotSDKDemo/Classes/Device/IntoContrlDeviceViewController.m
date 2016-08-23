//
//  IntoContrlDeviceViewController.m
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/20.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import "IntoContrlDeviceViewController.h"
#import "IntoRobotSDK.h"
#import "MBProgressHUD+IntoRobot.h"

@interface IntoContrlDeviceViewController ()<IntoRobotMQTTManagerDelegate,UITextFieldDelegate>
/** 类型 */
@property (nonatomic,strong) NSArray *sensorsArray;
/** 可写 */
@property (weak, nonatomic) IBOutlet UISwitch *cmdBool;
@property (weak, nonatomic) IBOutlet UISlider *cmdFloat;
@property (weak, nonatomic) IBOutlet UITextField *cmdString;
/**  只读 */
@property (weak, nonatomic) IBOutlet UISwitch *dataBool;
@property (weak, nonatomic) IBOutlet UISlider *dataFloat;
@property (weak, nonatomic) IBOutlet UITextField *dataString;

/** mqttManager */
@property (nonatomic,strong) IntoRobotMQTTManager *mqttManager ;
@end

@implementation IntoContrlDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loatDeviceInfo];
}

- (void)loatDeviceInfo{
    IntoWeakSelf;
    [IntoRobotAPIManager ml_requestDeviceInfo_GET_WithDeviceId:self.deviceId Progress:^(NSProgress *downloadProgress) {
        
    } successBlock:^(id responseObject) {
//        IntoLog(@"%@",responseObject);
        weakSelf.sensorsArray = responseObject[@"sensors"];
        [weakSelf mqttRequsetWithData:responseObject[@"sensors"]];
        
    } errorBlock:^(NSString *errorStr) {
        [MBProgressHUD showError:errorStr];
    }];

}

- (void)mqttRequsetWithData:(NSArray *)responseObject{
    
    self.mqttManager = [IntoRobotMQTTManager shareIntoRobotMQTTManager];
    self.mqttManager.ml_MQTTDelegate = self;
    [self.mqttManager ml_MqttConnectWithUser:self.userData[@"token"] pass:self.userData[@"userId"] connectHandle:^(int handEnumValue) {
//        IntoLog(@"%i",handEnumValue);
    }];
    
    // 一种封装方法
    for (NSDictionary *sensors in responseObject) {
        if ([sensors[@"sensorType"] isEqualToString:@"data"]) {
            [self.mqttManager ml_SubDeviceStatusWithDeviceId:self.deviceId sensorsDic:sensors SubHandle:^(NSDictionary *subscriptions) {}];
        }
    }
//    // 另一种方法
//    NSMutableDictionary *subDic = [NSMutableDictionary dictionary];
//    for (NSDictionary *sensors in responseObject) {
//        if ([sensors[@"sensorType"] isEqualToString:@"data"]) {
//            NSString *topic = [NSString stringWithFormat:@"v1/%@/channel/openapi/%@/%@",self.deviceId,sensors[@"sensorType"],sensors[@"name"]];
//            subDic[topic] = @(MQTTQosLevelAtMostOnce);
//        }
//    }
//    [self.mqttManager ml_SubScribeTopics:subDic SubHandle:^(NSDictionary *subscriptions) {
//        // 订阅的Topic
////        IntoLog(@"%@",subscriptions);
//    }];
}

- (IBAction)boolPub:(UISwitch *)sender {
    for (NSDictionary *sensorDic in self.sensorsArray) {
        if ([sensorDic[@"dataType"] isEqualToString:@"bool"] && [sensorDic[@"sensorType"] isEqualToString:@"cmd"]) {    // bool 可控
            NSString *boolValue = [NSString stringWithFormat:@"%d",sender.isOn];
            NSData *sendData = [boolValue dataUsingEncoding:NSUTF8StringEncoding];
            [self.mqttManager ml_PubDeviceStatusWithData:sendData DeviceId:self.deviceId sensorsDic:sensorDic];
            break;
        }
    }
}

- (IBAction)floatPub:(UISlider *)sender {
    for (NSDictionary *sensorDic in self.sensorsArray) {
        if ([sensorDic[@"dataType"] isEqualToString:@"float"] && [sensorDic[@"sensorType"] isEqualToString:@"cmd"]) {    // float 可控
            NSString *floatValue = [NSString stringWithFormat:@"%f",sender.value];
            NSData *sendData = [floatValue dataUsingEncoding:NSUTF8StringEncoding];
            [self.mqttManager ml_PubDeviceStatusWithData:sendData DeviceId:self.deviceId sensorsDic:sensorDic];
            break;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

// pub成功回调
- (void)ml_MessageDelivered:(UInt16)msgID
{
//    [MBProgressHUD showSuccess:@"Pub Success"];
}

// sub到数据回调
- (void)ml_HandleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained
{
    // 收到的数据
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // 确定自己的板子烧录的标识名为light_status
    if ([[[topic componentsSeparatedByString:@"/"] lastObject] isEqualToString:@"light_status"]) {
        self.dataBool.on = [dataString boolValue];
    }else if ([[[topic componentsSeparatedByString:@"/"] lastObject] isEqualToString:@"weather_status"]){
        self.dataFloat.value = [dataString floatValue];
    }else if ([[[topic componentsSeparatedByString:@"/"] lastObject] isEqualToString:@"text_status"]){
        self.dataString.text = dataString;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    for (NSDictionary *sensorDic in self.sensorsArray) {
        if ([sensorDic[@"dataType"] isEqualToString:@"string"] && [sensorDic[@"sensorType"] isEqualToString:@"cmd"]) {    // float 可控
            NSData *sendData = [textField.text dataUsingEncoding:NSUTF8StringEncoding];
            [self.mqttManager ml_PubDeviceStatusWithData:sendData DeviceId:self.deviceId sensorsDic:sensorDic];
            break;
        }
    }
    [self.view endEditing:YES];
    textField.text = nil;
    return YES;
}

@end
