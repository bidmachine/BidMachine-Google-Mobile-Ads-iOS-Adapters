//
//  WaterfallRewardedAdapter.swift
//  BidMachineAdMobAdapter
//
//  Created by Dzmitry on 03/12/2024.
//

import Foundation
import BidMachine
import GoogleMobileAds

@objc(BidMachineWaterfallCustomEventRewarded)
final class WaterfallRewardedAdapter: MediationAdapter {
    private var provider: BidMachineAdProvider<BidMachineRewarded>?

    func loadRewardedAd(
        for adConfiguration: GADMediationRewardedAdConfiguration,
        completionHandler: @escaping GADMediationRewardedLoadCompletionHandler
    ) {
        self.provider = .rewarded(strategy: .waterfall, completionHandler: completionHandler)
        self.provider?.loadAd(mediationParams: adConfiguration.credentials)
    }
}
