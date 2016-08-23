//
//  IntoDeviceInfoTableViewController.h
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/16.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^changeSuccessBlock) ();
@interface IntoDeviceInfoTableViewController : UITableViewController
/** 设备数据 */
@property (nonatomic,strong) NSDictionary *deviceDic;

/** 修改成功的回调 */
@property (nonatomic,copy) changeSuccessBlock changeSuccess;

@end
