//
//  IntoDeviceTableViewCell.h
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/17.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntoDeviceModel.h"

@interface IntoDeviceTableViewCell : UITableViewCell

+ (instancetype)cellWithTable:(UITableView *)tableView Style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
/** 设备字典数据 */
@property (nonatomic,strong) IntoDeviceModel *deviceModel;

@end
