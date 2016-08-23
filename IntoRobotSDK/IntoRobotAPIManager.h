//
//  IntoRobotAPIManager.h
//  IntoRobotSDKDemo
//
//  Created by 梁惠源 on 16/8/9.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

/** 下载进度 */
typedef void (^DownloadProgressBlock)(NSProgress * downloadProgress);
/** 上传进度 */
typedef void (^UploadProgressBlock)(NSProgress * uploadProgress);
/** 成功回调 */
typedef void (^SuccessBlock)(id responseObject);
/** 失败回调 */
typedef void (^ErrorBlock)(NSString * errorStr);
/** form表单 */
typedef void (^ConstructingBodyBlock)(id<AFMultipartFormData> formData);

@interface IntoRobotAPIManager : AFHTTPSessionManager

/**
 *  获取App token
 *
 *    获取验证码， 创建用户等操作都需要先获取app的token
 *    token可以控制接口的访问频率，避免恶意访问
 *    通过app的token，我们可以知道这款app对应的uid，用户系统，可以操作的产品类别。
 *    所以在创建用户，控制设备，获取验证码时都需要X-Intorobot-Application-Token
 */
+ (void)ml_requestAPPToken_GET_Progress:(DownloadProgressBlock)downloadProgress
                         successBlock:(SuccessBlock)successBlock
                           errorBlock:(ErrorBlock)errorBlock;

/**
 *  刷新 App token
 */
+ (void)ml_refreshAPPToken_PUT_SuccessBlock:(SuccessBlock)successBlock
                               errorBlock:(ErrorBlock)errorBlock;

/**
 *  获取图片验证码
 */
+ (void)ml_requestPicCode_GET_Progress:(DownloadProgressBlock)downloadProgress
                        successBlock:(SuccessBlock)successBlock
                          errorBlock:(ErrorBlock)errorBlock;
/**
 *  获取短信验证码
 *
 *  @param phone          手机号码
 *  @param zone           归属区号
 */
+ (void)ml_requestSMSCode_POST_WithPhone:(NSString *)phone
                                  Zone:(NSString *)zone
                              Progress:(UploadProgressBlock)uploadProgress
                          successBlock:(SuccessBlock)successBlock
                            errorBlock:(ErrorBlock)errorBlock;
/**
 *  获取邮箱验证码
 */
+ (void)ml_requestEmailCode_POST_WithEmail:(NSString *)email
                                Progress:(UploadProgressBlock)uploadProgress
                            successBlock:(SuccessBlock)successBlock
                              errorBlock:(ErrorBlock)errorBlock;
/**
 *  注册用户
 *
 *  创建用户. 根据app选择的用户系统，校验用户信息的格式。
 *  其中的token字段 跟 userId字段可以作为连入emqttd的用户名和密码
 *  noticeId 可以组成token默认控制的topic，用于消息推送
 *  用户的token可以对其名下所有设备进行控制|获取数据
 *
 *  @param email          邮箱
 *  @param username       用户名
 *  @param password       密码
 *  @param vldCode        验证码
 *
 */
+ (void)ml_registerUser_POST_WithEmail:(NSString *)email
                            username:(NSString *)username
                            password:(NSString *)password
                             vldCode:(NSString *)vldCode
                            Progress:(UploadProgressBlock)uploadProgress
                        successBlock:(SuccessBlock)successBlock
                          errorBlock:(ErrorBlock)errorBlock;
/**
 *  手机注册用户
 *
 *  创建用户. 根据app选择的用户系统，校验用户信息的格式。
 *  其中的token字段 跟 userId字段可以作为连入emqttd的用户名和密码
 *  noticeId 可以组成token默认控制的topic，用于消息推送
 *  用户的token可以对其名下所有设备进行控制|获取数据
 *
 *  @param phone          手机号
 *  @param username       用户名
 *  @param password       密码
 *  @param vldCode        验证码
 *
 */
+ (void)ml_registerUser_POST_WithPhone:(NSString *)phone
                              username:(NSString *)username
                              password:(NSString *)password
                               vldCode:(NSString *)vldCode
                              Progress:(UploadProgressBlock)uploadProgress
                          successBlock:(SuccessBlock)successBlock
                            errorBlock:(ErrorBlock)errorBlock;
/**
 *  邮箱登录
 *
 *  @param email    邮箱
 *  @param password 密码
 */
+ (void)ml_Login_POST_WithEmail:(NSString *)email
              andPassword:(NSString *)password
                 progress:(UploadProgressBlock)uploadProgress
             successBlock:(SuccessBlock)successBlock
               errorBlock:(ErrorBlock)errorBlock;
/**
 *  手机号码登录
 *
 *  @param phone    手机号
 *  @param password 密码
 */
+ (void)ml_Login_POST_WithPhone:(NSString *)phone
                    andPassword:(NSString *)password
                       progress:(UploadProgressBlock)uploadProgress
                   successBlock:(SuccessBlock)successBlock
                     errorBlock:(ErrorBlock)errorBlock;
/**
 *  重置邮箱密码
 *
 *  @param email        邮箱
 *  @param password     密码
 *  @param vldCode      验证码
 */
+ (void)ml_resetPW_PUT_WithEmail:(NSString *)email
                andPassword:(NSString *)password
                    vldCode:(NSString *)vldCode
               SuccessBlock:(SuccessBlock)successBlock
                 errorBlock:(ErrorBlock)errorBlock;
/**
 *  重置手机号密码
 *
 *  @param phone        手机号
 *  @param password     密码
 *  @param vldCode      验证码
 */
+ (void)ml_resetPW_PUT_WithPhone:(NSString *)phone
                     andPassword:(NSString *)password
                         vldCode:(NSString *)vldCode
                    SuccessBlock:(SuccessBlock)successBlock
                      errorBlock:(ErrorBlock)errorBlock;
/**
 *  请求用户信息
 *
 *  @param userId           用户ID
 */
+ (void)ml_requestUserInfo_GET_WithUserID:(NSString *)userId
                               progress:(DownloadProgressBlock)downloadProgress
                           successBlock:(SuccessBlock)successBlock
                             errorBlock:(ErrorBlock)errorBlock;
/**
 *  修改用户信息
 *
 *  @param userId       用户ID
 *  @param parameters   修改的值
 *  
 *  Example:
 *    {
 *        "username": "xiao kk",
 *        "desc": "i love sun shine."
 *    }
 */
+ (void)ml_changeUserInfo_PUT_WithUserID:(NSString *)userId
                            parameters:(NSMutableDictionary *)parameters
                          successBlock:(SuccessBlock)successBlock
                            errorBlock:(ErrorBlock)errorBlock;
/**
 *  退出登录
 *
 *  @param userId         用户userId
 */
+ (void)ml_Logout_GET_WithUserID:(NSString *)userId
                   progress:(DownloadProgressBlock)downloadProgress
               successBlock:(SuccessBlock)successBlock
                 errorBlock:(ErrorBlock)errorBlock;
/**
 *  更改密码
 *
 *  @param userId       用户ID
 *  @param curPassword  当前密码
 *  @param newPassword  新密码
 */
+ (void)ml_changePW_PUT_WithUserID:(NSString *)userId
                     curPassword:(NSString *)curPassword
                     newPassword:(NSString *)newPassword
                    successBlock:(SuccessBlock)successBlock
                      errorBlock:(ErrorBlock)errorBlock;
/**
 *  创建设备
 *
 *   分为两种情况：
 *
 *    1.板子里已经灌入了deviceId和token，可以直接连接平台(Atom, Neutron)；
 *    2.通过扫描二维码获取deviceId，需要在绑定的时候灌入deviceId和token;
 *
 *  @param name              设备名称
 *  @param deviceDesCription 设备描述
 *  @param deviceId          deviceId description
 */
+ (void)ml_createDevice_POST_WithName:(NSString *)name
                          description:(NSString *)deviceDesCription
                             deviceId:(NSString *)deviceId
                             progress:(UploadProgressBlock)uploadProgress
                         successBlock:(SuccessBlock)successBlock
                           errorBlock:(ErrorBlock)errorBlock;
/**
 *  获取用户设备列表
 */
+ (void)ml_requestUserDeviceList_GET_Progress:(DownloadProgressBlock)downloadProgress
                                 successBlock:(SuccessBlock)successBlock
                                   errorBlock:(ErrorBlock)errorBlock;
/**
 *  获取设备详细信息
 */
+ (void)ml_requestDeviceInfo_GET_WithDeviceId:(NSString *)deviceId
                                     Progress:(DownloadProgressBlock)downloadProgress
                                 successBlock:(SuccessBlock)successBlock
                                   errorBlock:(ErrorBlock)errorBlock;
/**
 *  修改设备详细信息
 *
 *  @param deviceId     设备ID
 *  @param parameters   修改的值
 */
+ (void)ml_changeDeviceInfo_PUT_WithDeviceId:(NSString *)deviceId
                                  parameters:(NSMutableDictionary *)parameters
                                successBlock:(SuccessBlock)successBlock
                                  errorBlock:(ErrorBlock)errorBlock;
/**
 *  删除设备
 */
+ (void)ml_deleteDevice_DELETE_WithDeviceId:(NSString *)deviceId
                                 successBlock:(SuccessBlock)successBlock
                                   errorBlock:(ErrorBlock)errorBlock;
/**
 *  发送控制指令
 *
 *  @param deviceId       设备ID
 */
+ (void)ml_sendControlOrder_POST_WithDeviceId:(NSString *)deviceId
                                   parameters:(NSMutableDictionary *)parameters
                                     progress:(UploadProgressBlock)uploadProgress
                                 successBlock:(SuccessBlock)successBlock
                                   errorBlock:(ErrorBlock)errorBlock;
@end
