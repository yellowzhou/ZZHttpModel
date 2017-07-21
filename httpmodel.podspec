#
#  Be sure to run `pod spec lint httpmodel.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

# pod lib lint --allow-warnings --use-libraries --verbose
# pod lib lint httpmodel.podspec --allow-warnings
# pod trunk push httpmodel.podspec --allow-warnings
# pod trunk me

Pod::Spec.new do |s|

  s.platform     = :ios
  s.ios.deployment_target = "8.0"

  s.name         = "httpmodel"
  s.version      = "2.2"
  s.summary      = "Dictionary <=> Model <=> JSON"

  s.homepage     = "https://github.com/yellowzhou/ZZHttmModel"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "yellowzhou" => "yellowzhou@sina.cn" }
  s.source       = { :git => "https://github.com/yellowzhou/ZZHttmModel.git", :tag => "#{s.version}" }
  s.framework = "CFNetwork","Foundation"

  s.source_files  = "ZZHttpModel/**/*.{h,m}"
  s.requires_arc = true
  s.dependency "AFNetworking", "~> 3.1.0"

end
