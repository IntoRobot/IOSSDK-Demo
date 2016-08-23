//
//  IntoRobotMQTTManager.h
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/13.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import "MQTTSessionManager.h"
#import "IntoRobotSDK.h"

@protocol IntoRobotMQTTManagerDelegate <NSObject>

/**
 *  sub到消息的时候回调
 *
 *  @param data     数据
 *  @param topic    topic
 *  @param retained retained
 */
- (void)ml_HandleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained;

@optional

/** gets called when a published message was actually delivered
 @param msgID the Message Identifier of the delivered message
 @note this method is called after a publish with qos 1 or 2 only
 */
/**
 *  pub消息成功时回调，只有当 qos 为1或者2
 *
 *  @param msgID msgID
 */
- (void)ml_MessageDelivered:(UInt16)msgID;

@end

@interface IntoRobotMQTTManager : MQTTSessionManager

/** the delegate receiving incoming messages
 */
@property (weak, nonatomic) id<IntoRobotMQTTManagerDelegate> ml_MQTTDelegate;

/** 单例对象 */
+ (instancetype)shareIntoRobotMQTTManager;

/**
 *  连接MQTT
 *  @param user           用户名
 *  @param pass           密码
 *  @param handle         回调枚举值
 
 typedef NS_ENUM(int, MQTTSessionManagerState) {
     MQTTSessionManagerStateStarting,
     MQTTSessionManagerStateConnecting,
     MQTTSessionManagerStateError,
     MQTTSessionManagerStateConnected,
     MQTTSessionManagerStateClosing,
     MQTTSessionManagerStateClosed
 };
 */
- (void)ml_MqttConnectWithUser:(NSString *)user
                          pass:(NSString *)pass
                 connectHandle:(void(^)(int handEnumValue))handle;

/**
 *  发送数据
 *
 *  @param data       数据
 *  @param topic      topic
 *  @param qos        qos等级
 *  @param retainFlag retainFlag
 */
- (void)ml_PublishData:(NSData *)data topic:(NSString *)topic qos:(MQTTQosLevel)qos retain:(BOOL)retainFlag;

/**
 *  sub数据
 *  connect连接成功之后的sub
 *  keys 是topic
 *
 *  @param topicDic 以qos等级和topic为键值对的字典
 */
- (void)ml_SubScribeTopics:(NSDictionary <NSString *, NSNumber *>*)topicDic SubHandle:(void(^)(NSDictionary *subscriptions))handle;

/**
 *  unSub数据
 *
 *  @param topic unsub掉的topic
 */
- (void)ml_UnSubScribeTopic:(NSString *)topic unSubHandle:(void (^)(NSDictionary *subscriptions))handle;
/**
 *  disConnect
 *
 *  @param handle 回调结果
 */
- (void)ml_MqttDisConnectHandle:(void (^)(int handEnumValue))handle;
/**
 *  sub设备在线状态
 *
 *  @param deviceId 设备Id
 */
- (void)ml_SubDeviceOnlineStatusWithDeviceId:(NSString *)deviceId SubHandle:(void(^)(NSDictionary *subscriptions))handle;

/**
 *  sub设备producer
 *
 *  @param deviceId  设备Id
 *  @param sensorDic sensor
 *  @param handle    回调
 */
- (void)ml_SubDeviceStatusWithDeviceId:(NSString *)deviceId sensorsDic:(NSDictionary *)sensorDic SubHandle:(void(^)(NSDictionary *subscriptions))handle;
/**
 *  pub设备producer
 *
 *  @param data      数据
 *  @param deviceId  设备Id
 *  @param sensorDic sensor
 *  @param handle    回调
 */
- (void)ml_PubDeviceStatusWithData:(NSData *)data DeviceId:(NSString *)deviceId sensorsDic:(NSDictionary *)sensorDic;


@end
