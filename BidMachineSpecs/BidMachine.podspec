Pod::Spec.new do |spec|
  spec.name                     = "BidMachine"
  spec.version                  = "2.0.1.0"
  spec.summary                  = "BidMachine iOS SDK"

  spec.homepage                 = "https://bidmachine.io"
  spec.license                  = { :type => 'GPL 3.0', :file => 'LICENSE' }
  spec.author                   = { "Stack" => "https://explorestack.com/bidmachine/" }

  spec.platform                 = :ios, '10.0'
  spec.swift_version            = "5.1"
  
  spec.pod_target_xcconfig = {
    "VALID_ARCHS": "arm64 armv7 x86_64",
    "VALID_ARCHS[sdk=iphoneos*]": "arm64 armv7",
    "VALID_ARCHS[sdk=iphonesimulator*]": "arm64 x86_64"
  }

  spec.source                   = { :http => "https://s3-us-west-1.amazonaws.com/appodeal-ios/#{spec.name}/#{spec.version}/#{spec.name}.zip" }
  spec.vendored_frameworks = "#{spec.name}.xcframework", "BidMachineAdapterCore.xcframework"

  spec.dependency 'StackIAB', '~> 2.0.0'
  spec.dependency 'StackModules', '~> 1.3.1'

  spec.dependency 'BidMachineApiCore', '~> 0.1.0'
  spec.dependency 'BidMachineNetworkCore', '~> 0.1.0'
  spec.dependency 'BidMachineDisplayCore', '~> 0.2.0'
  spec.dependency 'BidMachineBiddingCore', '~> 0.1.0'
  spec.dependency 'BidMachineAnalyticsCore', '~> 0.2.0'
end
