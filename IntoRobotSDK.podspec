Pod::Spec.new do |s|
  s.name         = "IntoRobotSDK"
  s.version      = "0.1.0"
  s.ios.deployment_target = '8.0'
  s.summary      = "IntoRobotSDK of The Molmc for iOS"
  s.homepage     = "https://github.com/IntoRobot/IntoRobotSDK"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "邵银岭" => "534585931@qq.com" }
  s.social_media_url   = "https://github.com/IntoRobot"
  s.source       = { :git => "https://github.com/IntoRobot/IntoRobotSDK.git", :tag => s.version }
  s.source_files  = "IntoRobotSDK"
  s.requires_arc = true
  s.dependency 'AFNetworking'
  s.dependency 'MQTTClient'
  s.dependency 'CocoaAsyncSocket'
end