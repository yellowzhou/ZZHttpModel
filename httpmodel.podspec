
# pod lib lint --allow-warnings --use-libraries --verbose
# pod lib lint httpmodel.podspec --allow-warnings
# pod trunk push httpmodel.podspec --allow-warnings
# pod trunk me
# pod repo update

# pod trunk delete NAME VERSION
# pod trunk delete httpmodel 2.2

Pod::Spec.new do |s|

  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"

  s.name         = "httpmodel"
  s.version      = "0.0.1"
  s.summary      = "Dictionary <=> Model <=> JSON"

  s.homepage     = "https://github.com/yellowzhou/ZZHttmModel"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "yellowzhou" => "yellowzhou@sina.cn" }
  s.source       = { :git => "https://github.com/yellowzhou/ZZHttmModel.git", :tag => "#{s.version}" }
  s.framework = "CFNetwork","Foundation"

  s.source_files  = "ZZHttpModel/Src/*.{h,m}"
  s.requires_arc = true
  s.dependency "AFNetworking"

end
