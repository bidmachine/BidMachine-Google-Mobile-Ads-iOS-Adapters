//
//  BaseAdapter.swift
//  BidMachineAdMobAdapter
//
//  Created by Ilia Lozhkin on 20.12.2022.
//

import Foundation
import BidMachine
import GoogleMobileAds

@objc class MediationAdapter: NSObject, GADMediationAdapter {
    
    static func adapterVersion() -> GADVersionNumber {
        return GADVersionNumber.version(BidMachineAdapter.adapterVersionPath + ".0")
    }
    
    static func adSDKVersion() -> GADVersionNumber {
        return GADVersionNumber.version(BidMachineSdk.sdkVersion)
    }
    
    static func networkExtrasClass() -> GADAdNetworkExtras.Type? {
        nil
    }
    
    required override init() {
        
    }

    static func setUpWith(
        _ configuration: GADMediationServerConfiguration,
        completionHandler: @escaping GADMediationAdapterSetUpCompletionBlock
    ) {
        let credentials = configuration.credentials.first
        
        defer { completionHandler(nil) }
        
        guard !BidMachineSdk.shared.isInitialized, let sourceID = try? credentials?.mediationSettings().sourceID else {
            return
        }
        BidMachineSdk.shared.initializeSdk(sourceID)
    }
}
