
platform :ios, '10.0'
install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false

$BDMVersion = '~> 1.9.4.0'
$GoogleVersion = '~> 9.8.0'

def bidmachine
  pod "BDMIABAdapter", $BDMVersion
  pod "BDMAdColonyAdapter", $BDMVersion
  pod "BDMAmazonAdapter", $BDMVersion
  pod "BDMCriteoAdapter", $BDMVersion
  pod "BDMFacebookAdapter", $BDMVersion
  pod "BDMMyTargetAdapter", $BDMVersion
  pod "BDMSmaatoAdapter", $BDMVersion
  pod "BDMTapjoyAdapter", $BDMVersion
  pod "BDMVungleAdapter", $BDMVersion
end

def google 
  pod 'Google-Mobile-Ads-SDK', $GoogleVersion
end

target 'BidMachineSample' do
  google
  bidmachine

end
