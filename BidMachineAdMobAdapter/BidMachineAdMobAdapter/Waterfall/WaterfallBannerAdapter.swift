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
        self.provider = .banner(
            format: .fromAdSize(adConfiguration.adSize),
            strategy: .waterfall,
            completionHandler: completionHandler
        )
        self.provider?.loadAd(mediationParams: adConfiguration.credentials)
    }
}

extension BidMachine.AdFormat {
    static func fromAdSize(_ size: AdSize) -> BidMachine.AdFormat {
        // Standard Banner - 320x50
        if isAdSizeEqualToSize(size1: size, size2: AdSizeBanner) {
            return .banner320x50
        }
        
        // Leaderboard - 728x90
        if isAdSizeEqualToSize(size1: size, size2: AdSizeLeaderboard) {
            return .banner728x90
        }
        
        // Medium Rectangle - 300x250
        if isAdSizeEqualToSize(size1: size, size2: AdSizeMediumRectangle) {
            return .banner300x250
        }
        
        // Large Banner - 320x100
        if isAdSizeEqualToSize(size1: size, size2: AdSizeLargeBanner) {
            return .bannerAdaptive(width: 320, maxHeight: 100)
        }
        
        // Full Banner - 468x60
        if isAdSizeEqualToSize(size1: size, size2: AdSizeFullBanner) {
            return .bannerAdaptive(width: 468, maxHeight: 60)
        }
        
        // Skyscraper - 120x600
        if isAdSizeEqualToSize(size1: size, size2: AdSizeSkyscraper) {
            return .bannerAdaptive(width: 120, maxHeight: 600)
        }
        let height = UInt32(size.size.height)
        let width = UInt32(size.size.width)

        return .bannerAdaptive(width: width, maxHeight: height)
    }
}
