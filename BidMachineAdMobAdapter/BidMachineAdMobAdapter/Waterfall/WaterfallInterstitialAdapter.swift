//
//  WaterfallInterstitialAdapter.swift
//  BidMachineAdMobAdapter
//
//  Created by Dzmitry on 03/12/2024.
//

import Foundation
import BidMachine
import GoogleMobileAds

@objc(BidMachineWaterfallCustomEventInterstitial)
final class WaterfallInterstitialAdapter: MediationAdapter {
    private var provider: BidMachineAdProvider<BidMachineInterstitial>?
    
    func loadInterstitial(
        for adConfiguration: GADMediationInterstitialAdConfiguration,
        completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler
    ) {
        self.provider = .interstitial(strategy: .waterfall, completionHandler: completionHandler)
        self.provider?.loadAd(mediationParams: adConfiguration.credentials)
    }
}
