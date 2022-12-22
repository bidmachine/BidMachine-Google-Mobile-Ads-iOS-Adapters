
platform :ios, '10.0'
install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false

workspace 'BidMachineAdMobAdapter.xcworkspace'

source 'https://github.com/appodeal/CocoaPods.git'
source 'https://cdn.cocoapods.org/'

$BDMVersion = '~> 2.0.1.0'
$GoogleVersion = '~> 9.14.0'

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

target 'BidMachineAdMobAdapter' do
  project 'BidMachineAdMobAdapter/BidMachineAdMobAdapter.xcodeproj'
  google
  bidmachine

end
