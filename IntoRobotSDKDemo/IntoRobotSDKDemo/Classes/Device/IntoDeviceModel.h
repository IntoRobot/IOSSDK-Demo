//
//  IntoDeviceModel.h
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/17.
//  Copyright © 2016年 MOLMC. All rights reserved.
//
//  为了监听设备在线临时模型

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface IntoDeviceModel : NSObject

@property (nonatomic,copy) NSString *deviceDescription;
@property (nonatomic,copy) NSString *deviceId;
@property (nonatomic,assign) BOOL locked;
@property (nonatomic,copy) NSString *bindAt;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *productId;
/***********辅助********************************/
@property (nonatomic,assign) BOOL online;

@end
