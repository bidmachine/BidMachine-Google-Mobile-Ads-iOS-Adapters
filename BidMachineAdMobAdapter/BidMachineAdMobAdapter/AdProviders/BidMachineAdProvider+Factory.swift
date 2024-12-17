//
//  BidMachineAdProvider+Factiry.swift
//  BidMachineAdMobAdapter
//
//  Created by Dzmitry on 03/12/2024.
//

import Foundation
import BidMachine
import GoogleMobileAds

extension BidMachineAdProvider {
    enum MediationStrategy {
        case waterfall
        case prebid
    }

    static func banner(
        format: PlacementFormat,
        strategy: MediationStrategy,
        completionHandler: @escaping GADMediationBannerLoadCompletionHandler
    ) -> BidMachineAdProvider<BidMachineBanner> {
        return provider(
            strategy: strategy,
            format: format,
            success: {
                let ad = BannerAd($0)
                ad.delegate = completionHandler(ad, nil)
            },
            failure: { _ = completionHandler(nil, $0) }
        )
    }
    
    static func interstitial(
        strategy: MediationStrategy,
        completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler
    ) -> BidMachineAdProvider<BidMachineInterstitial> {
        return provider(
            strategy: strategy,
            format: .interstitial,
            success: {
                let ad = InterstitialAd($0)
                ad.delegate = completionHandler(ad, nil)
            },
            failure: { _ = completionHandler(nil, $0) }
        )
    }
    
    static func rewarded(
        strategy: MediationStrategy,
        completionHandler: @escaping GADMediationRewardedLoadCompletionHandler
    ) -> BidMachineAdProvider<BidMachineRewarded> {
        return provider(
            strategy: strategy,
            format: .rewarded,
            success: {
                let ad = RewardedAd($0)
                ad.delegate = completionHandler(ad, nil)
            },
            failure: { _ = completionHandler(nil, $0) }
        )
    }
    
    static func native(
        strategy: MediationStrategy,
        completionHandler: @escaping GADMediationNativeLoadCompletionHandler
    ) -> BidMachineAdProvider<BidMachineNative> {
        return provider(
            strategy: strategy,
            format: .native,
            success: {
                let ad = NativeAd($0)
                ad.delegate = completionHandler(ad, nil)
            },
            failure: { _ = completionHandler(nil, $0) }
        )
    }

    private static func provider<Ad: BidMachineAdProtocol>(
        strategy: MediationStrategy,
        format: PlacementFormat,
        success: @escaping (Ad) -> Void,
        failure: @escaping (Error) -> Void
    ) -> BidMachineAdProvider<Ad> {
        switch strategy {
        case .waterfall:
            let strategy = WaterfallMediationStrategy(
                success: success,
                failure: failure
            )
            return BidMachineAdProvider<Ad>(
                format: format,
                strategy: strategy
            )

        case .prebid:
            let strategy = PrebidMediationStrategy(
                success: success,
                failure: failure
            )
            return BidMachineAdProvider<Ad>(
                format: format,
                strategy: strategy
            )
        }
    }
}
