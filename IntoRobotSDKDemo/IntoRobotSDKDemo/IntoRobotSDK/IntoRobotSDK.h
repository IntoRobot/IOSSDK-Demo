//
//  IntoRobotSDK.h
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/10.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#ifndef IntoRobotSDK_h
#define IntoRobotSDK_h

#import "IntoRobotSDKManager.h"
#import "IntoRobotMQTTManager.h"
#import "NSString+MLString.h"

// 阿里云
#define API_Base_DOMAIN @"api.intorobot.com/v1"

// HTTP请求服务器地址
#define API_Base_URL [NSString stringWithFormat:@"https://%@", API_Base_DOMAIN]

// MQTT阿里云
#define MQTT_Base_DOMAIN @"iot.intorobot.com"

// MQTT 端口号
#define MQTT_Base_PORT 1883

#define API_CONFIG(url) [NSString stringWithFormat:@"%@%@", API_Base_URL, url]
#define MQTT_CONFIG(url) [NSString stringWithFormat:@"%@%@", MQTT_Base_DOMAIN, url]

/** 日志输出 */
#ifdef DEBUG // 开发

#define IntoLog(...) NSLog(@"%s %d \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])

#else // 发布

#define IntoLog(...)

#endif

#define IntoWeakSelf __weak typeof(self) weakSelf = self;
#endif /* IntoRobotSDK_h */
