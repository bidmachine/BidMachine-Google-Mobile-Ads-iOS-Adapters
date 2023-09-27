
platform :ios, '11.0'
install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false

$BDMVersion = '~> 1.9.5.1'
$GoogleVersion = '~> 10.11.0'

def bidmachine
  pod "BDMIABAdapter", $BDMVersion
end

def google 
  pod 'Google-Mobile-Ads-SDK', $GoogleVersion
end

target 'BidMachineSample' do
  google
  bidmachine

end
