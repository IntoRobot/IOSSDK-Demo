//
//  IntoCreateDeviceViewController.h
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/16.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^createSuccessBlock) ();
@interface IntoCreateDeviceViewController : UIViewController
/** 创建成功的 */
@property (nonatomic,copy) createSuccessBlock createSuccess;
@end
