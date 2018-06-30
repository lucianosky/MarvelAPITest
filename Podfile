platform :ios, '11.0'

def common_pods
    pod 'Alamofire', '~> 4.4'
    pod 'Kingfisher', '~> 4.8'
end

target 'MarvelAPIApp' do
    common_pods
end

target 'MarvelAPIAppTests' do
    common_pods
end

target 'MarvelAPIAppUITests' do
    common_pods
end

post_install do |installer|
    
    # Disable code coverage for all Pods and Pods Project
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
        end
    end
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
    end
end

