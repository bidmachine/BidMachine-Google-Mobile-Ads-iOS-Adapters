Pod::Spec.new do |spec|
  spec.name                = "BidMachineAdMobAdapter"
  spec.version             = "3.1.1.2-beta.1"
  spec.summary             = "Bidmachine adapter for AdMob"

  spec.homepage            = "https://bidmachine.io"
  spec.license             = { :type => "Commercial License",
                               :text => "Copyright #{Time.new.year}. Appodeal Inc. All rights reserved.\nThe #{spec.name} is available under a commercial license (https://appodeal.com/sdk-license-agreement)." }
  spec.author              = { "Stack" => "https://explorestack.com/bidmachine/" }

  spec.platform            = :ios, "12.0"
  spec.swift_version       = "5.1"

  spec.pod_target_xcconfig = {
    "OTHER_LDFLAGS": "-ObjC",
  }

  spec.source = { :http => "https://bidmachine-ios.s3.amazonaws.com/#{spec.name}/#{spec.version}/pod/#{spec.name}.zip" }
  spec.vendored_frameworks = "release/Static/#{spec.name}.xcframework"
  spec.resource_bundles = {
    "#{spec.name}" => ["release/Static/#{spec.name}.xcframework/ios-arm64/**/PrivacyInfo.xcprivacy"],
  }

  spec.dependency "BidMachine", "~> 3.1.1"
  spec.dependency "Google-Mobile-Ads-SDK", "~> 11.13.0"

end