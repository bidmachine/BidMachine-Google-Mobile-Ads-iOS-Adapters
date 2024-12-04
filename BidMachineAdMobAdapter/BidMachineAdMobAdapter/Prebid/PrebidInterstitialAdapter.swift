//
//  PrebidInterstitialAdapter.swift
//  BidMachineAdMobAdapter
//
//  Created by Dzmitry on 03/12/2024.
//

import Foundation
import BidMachine
import GoogleMobileAds

@objc(BidMachineCustomEventInterstitial)
final class PrebidInterstitialAdapter: MediationAdapter {
    private var provider: BidMachineAdProvider<BidMachineInterstitial>?
    
    func loadInterstitial(
        for adConfiguration: GADMediationInterstitialAdConfiguration,
        completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler
    ) {
        self.provider = .interstitial(strategy: .prebid, completionHandler: completionHandler)
        self.provider?.loadAd(mediationParams: adConfiguration.credentials)
    }
}
