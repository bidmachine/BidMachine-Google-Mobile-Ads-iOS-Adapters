platform :ios, '12.0'
use_frameworks!

install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false

workspace 'BidMachineAdMobAdapter.xcworkspace'

source 'https://cdn.cocoapods.org/'

$BDMVersion = '~> 3.3.0'
$GoogleVersion = '~> 12.6.0'

def bidmachine
  pod "BidMachine", $BDMVersion
end

def google 
  pod 'Google-Mobile-Ads-SDK', $GoogleVersion
end

target 'BidMachineSample' do
  project 'BidMachineSample/BidMachineSample.xcodeproj'
  google
  bidmachine

end

target 'BidMachineWaterfallSample' do
  project 'BidMachineWaterfallSample/BidMachineWaterfallSample.xcodeproj'
  google
  bidmachine

end

target 'BidMachineSampleSwift' do
  project 'BidMachineSampleSwift/BidMachineSampleSwift.xcodeproj'
  google
  bidmachine

end

target 'BidMachineWaterfallSampleSwift' do
  project 'BidMachineWaterfallSampleSwift/BidMachineWaterfallSampleSwift.xcodeproj'
  google
  bidmachine

end

target 'BidMachineAdMobAdapter' do
  project 'BidMachineAdMobAdapter/BidMachineAdMobAdapter.xcodeproj'
  google
  bidmachine

end

# Post install configuration
post_install do |installer|
  project = installer.pods_project
  project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end
