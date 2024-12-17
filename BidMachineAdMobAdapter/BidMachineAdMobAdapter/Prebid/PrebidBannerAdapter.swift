//
//  PrebidBannerAdapter.swift
//  BidMachineAdMobAdapter
//
//  Created by Dzmitry on 03/12/2024.
//

import Foundation
import BidMachine
import GoogleMobileAds

@objc(BidMachineCustomEventBanner)
final class PrebidBannerAdapter: MediationAdapter {
    private var provider: BidMachineAdProvider<BidMachineBanner>?
    
    func loadBanner(
        for adConfiguration: GADMediationBannerAdConfiguration,
        completionHandler: @escaping GADMediationBannerLoadCompletionHandler
    ) {
        self.provider = .banner(
            format: adConfiguration.adSize.size.format,
            strategy: .prebid,
            completionHandler: completionHandler
        )
        self.provider?.loadAd(mediationParams: adConfiguration.credentials)
    }
}
