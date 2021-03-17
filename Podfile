
platform :ios, '10.0'

install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false

source 'https://github.com/appodeal/CocoaPods.git'
source 'https://github.com/CocoaPods/Specs.git'


def bidmachine
  pod "BidMachine", "1.6.4"
  pod "BidMachine/Adapters"
end

def google 
  pod 'Google-Mobile-Ads-SDK', '~> 8.2.0'
end

target 'BidMachineSample' do
  google
  bidmachine
end
