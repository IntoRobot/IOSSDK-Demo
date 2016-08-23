//
//  IntoContrlDeviceViewController.h
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/20.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntoContrlDeviceViewController : UIViewController
/** 设备ID */
@property (nonatomic,copy) NSString *deviceId;
/** 用户信息 */
@property (nonatomic,strong) NSDictionary *userData;

@end
