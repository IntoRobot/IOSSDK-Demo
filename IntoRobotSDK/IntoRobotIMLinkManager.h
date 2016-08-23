//
//  IntoRobotIMLinkManager.h
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/12.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntoRobotSDK.h"

@interface IntoRobotIMLinkManager : NSObject

/**
 *  创建设备
 *
 *  @param deviceName   设备名称
 *  @param WiFiPwd      WiFi密码
 */
- (void)creatDeviceWithDeviceName:(NSString *)deviceName
                          WiFiPwd:(NSString *)WiFiPwd
                     successBlock:(SuccessBlock)successBlock
                       errorBlock:(ErrorBlock)errorBlock;

@end
