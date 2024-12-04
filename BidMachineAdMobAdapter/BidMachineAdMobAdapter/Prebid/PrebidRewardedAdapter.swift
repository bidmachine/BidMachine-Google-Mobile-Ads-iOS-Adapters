//
//  PrebidRewardedAdapter.swift
//  BidMachineAdMobAdapter
//
//  Created by Dzmitry on 03/12/2024.
//

import Foundation
import BidMachine
import GoogleMobileAds

@objc(BidMachineCustomEventRewarded)
final class PrebidRewardedAdapter: MediationAdapter {
    private var provider: BidMachineAdProvider<BidMachineRewarded>?

    func loadRewardedAd(
        for adConfiguration: GADMediationRewardedAdConfiguration,
        completionHandler: @escaping GADMediationRewardedLoadCompletionHandler
    ) {
        self.provider = .rewarded(strategy: .prebid, completionHandler: completionHandler)
        self.provider?.loadAd(mediationParams: adConfiguration.credentials)
    }
}
