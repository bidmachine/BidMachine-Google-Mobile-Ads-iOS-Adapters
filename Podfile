
platform :ios, '9.0'
workspace 'AdMobBidMachineSample.xcworkspace'

install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false

source 'https://github.com/appodeal/CocoaPods.git'
source 'https://github.com/CocoaPods/Specs.git'


def bidmachine_header_bidding
  pod "BidMachine", "1.4.3.1"
  pod "BidMachine/Adapters"
end


target 'AdMobBidMachineSample' do
  project 'AdMobBidMachineSample/AdMobBidMachineSample.xcodeproj'
  pod 'GoogleMobileAdsMediationTestSuite'
  pod 'Google-Mobile-Ads-SDK', '~> 7.58'
  bidmachine_header_bidding
end

 
target 'BidMachineAdapter' do
  project 'AdMobBidMachineSample/AdMobBidMachineSample.xcodeproj'
  pod 'Google-Mobile-Ads-SDK', '~> 7.58'
  bidmachine_header_bidding
end

target 'BidMachineAdMobAdManager' do
  project 'BidMachineAdMobAdManager/BidMachineAdMobAdManager.xcodeproj'
  pod 'Google-Mobile-Ads-SDK', '~> 7.58'
  bidmachine_header_bidding
end

target 'AdMobManagerBidMachineSample' do
  project 'AdMobManagerBidMachineSample/AdMobManagerBidMachineSample.xcodeproj'
  pod 'Google-Mobile-Ads-SDK', '~> 7.58'
  bidmachine_header_bidding
end