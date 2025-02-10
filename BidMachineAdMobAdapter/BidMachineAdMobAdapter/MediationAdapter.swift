//
//  BaseAdapter.swift
//  BidMachineAdMobAdapter
//
//  Created by Ilia Lozhkin on 20.12.2022.
//

import Foundation
import BidMachine
import GoogleMobileAds

@objc class MediationAdapter: NSObject, GoogleMobileAds.MediationAdapter {
    
    static func adapterVersion() -> VersionNumber {
        return .version(BidMachineAdapter.adapterVersionPath + ".0")
    }
    
    static func adSDKVersion() -> VersionNumber {
        return .version(BidMachineSdk.sdkVersion)
    }
    
    static func networkExtrasClass() -> AdNetworkExtras.Type? {
        nil
    }
    
    required override init() {
        
    }
    
    static func setUp(
        with configuration: MediationServerConfiguration,
        completionHandler: @escaping GADMediationAdapterSetUpCompletionBlock
    ) {
        defer { completionHandler(nil) }
        
        guard
            !BidMachineSdk.shared.isInitialized,
            let credential = configuration.credentials.first,
            let sourceID = try? credential.mediationSettings().sourceID
        else {
            return
        }
        BidMachineSdk.shared.initializeSdk(sourceID)
    }
}
