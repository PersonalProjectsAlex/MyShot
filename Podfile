# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MyShot' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MyShot


   # Core PODS
  pod 'Alamofire'
  pod 'CodableAlamofire'
  pod 'SDWebImage', '~> 4.0'
  pod 'SwiftyBeaver'
  pod 'Firebase'
  pod 'Firebase/Storage'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'

   # Network/ Accounts
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'Google/SignIn'

   # Utils
  pod 'XLPagerTabStrip', '~> 8.0'
  pod 'IQKeyboardManagerSwift', '~> 5.0'
  pod 'Cosmos'
  pod 'HexColors'
  pod 'ImageSlideshow', '~> 1.5'
  pod "ImageSlideshow/Kingfisher"
  pod 'PopupDialog', '~> 0.7'
  pod 'Hero'
  pod 'lottie-ios'
  pod 'SideMenu'
  pod 'NVActivityIndicatorView'
  pod 'TweeTextField'
  pod 'Spring', :git => 'https://github.com/MengTo/Spring.git'
  pod 'LTMorphingLabel'
  pod 'SwiftMessages'
  pod "BWWalkthrough"

  post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings.delete('CODE_SIGNING_ALLOWED')
            config.build_settings.delete('CODE_SIGNING_REQUIRED')
        end
    end
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end

  
end
