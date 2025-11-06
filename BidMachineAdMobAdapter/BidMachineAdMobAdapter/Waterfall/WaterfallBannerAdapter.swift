//
//  WaterfallBannerAdapter.swift
//  BidMachineAdMobAdapter
//
//  Created by Dzmitry on 03/12/2024.
//

import Foundation
import BidMachine
import GoogleMobileAds

@objc(BidMachineWaterfallCustomEventBanner)
final class WaterfallBannerAdapter: MediationAdapter {
    private var provider: BidMachineAdProvider<BidMachineBanner>?
    
    func loadBanner(
        for adConfiguration: MediationBannerAdConfiguration,
        completionHandler: @escaping GADMediationBannerLoadCompletionHandler
    ) {
        self.provider = .bannerOrFail(
            googleSize: adConfiguration.adSize,
            strategy: .waterfall,
            completionHandler: completionHandler
        )
        self.provider?.loadAd(mediationParams: adConfiguration.credentials)
    }
}
