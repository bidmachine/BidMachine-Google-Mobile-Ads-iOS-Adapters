//
//  WaterfallNativeAdapter.swift
//  BidMachineAdMobAdapter
//
//  Created by Dzmitry on 03/12/2024.
//

import Foundation
import BidMachine
import GoogleMobileAds

@objc(BidMachineWaterfallCustomEventNativeAd)
final class WaterfallNativeAdapter: MediationAdapter {
    private var provider: BidMachineAdProvider<BidMachineNative>?

    func loadNativeAd(
        for adConfiguration: MediationNativeAdConfiguration,
        completionHandler: @escaping GADMediationNativeLoadCompletionHandler
    ) {
        self.provider = .native(strategy: .waterfall, completionHandler: completionHandler)
        self.provider?.loadAd(mediationParams: adConfiguration.credentials)
    }
}
