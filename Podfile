#inhibit_all_warnings!

target 'ZZHttpModel' do
    ## pod install --verbose --no-repo-update
    pod 'AFNetworking', '~> 3.0.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end



