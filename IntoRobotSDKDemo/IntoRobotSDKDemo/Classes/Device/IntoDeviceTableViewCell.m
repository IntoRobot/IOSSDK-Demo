//
//  IntoDeviceTableViewCell.m
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/17.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import "IntoDeviceTableViewCell.h"
#import "MBProgressHUD+IntoRobot.h"

@interface IntoDeviceTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceDescripLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlineStatus;

@end

@implementation IntoDeviceTableViewCell

+ (instancetype)cellWithTable:(UITableView *)tableView Style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    IntoDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([IntoDeviceTableViewCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setDeviceModel:(IntoDeviceModel *)deviceModel
{
    _deviceModel = deviceModel;
    
    self.deviceNameLabel.text = deviceModel.name;
    self.deviceDescripLabel.text = deviceModel.deviceDescription;
    if (deviceModel.online) {
        self.onlineStatus.text = @"在线";
    }else{
        self.onlineStatus.text = @"不在线";
    }
}

@end
