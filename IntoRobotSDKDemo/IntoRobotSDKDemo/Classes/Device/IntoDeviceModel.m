//
//  IntoDeviceModel.m
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/17.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import "IntoDeviceModel.h"

@implementation IntoDeviceModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"deviceDescription":@"description"
             };
}
@end
