//
//  IntoRobotSDKErrorInfo.h
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/10.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntoRobotSDKErrorInfo : NSObject

+ (NSString *)httpStatusError:(NSError *)error;

@end
