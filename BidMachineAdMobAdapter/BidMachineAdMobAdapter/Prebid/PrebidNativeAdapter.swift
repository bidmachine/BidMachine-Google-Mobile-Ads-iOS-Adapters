//
//  PrebidNativeAdapter.swift
//  BidMachineAdMobAdapter
//
//  Created by Dzmitry on 03/12/2024.
//

import Foundation
import BidMachine
import GoogleMobileAds

@objc(BidMachineCustomEventNativeAd)
final class PrebidNativeAdapter: MediationAdapter {
    private var provider: BidMachineAdProvider<BidMachineNative>?

    func loadNativeAd(
        for adConfiguration: MediationNativeAdConfiguration,
        completionHandler: @escaping GADMediationNativeLoadCompletionHandler
    ) {
        self.provider = .native(strategy: .prebid, completionHandler: completionHandler)
        self.provider?.loadAd(mediationParams: adConfiguration.credentials)
    }
}
