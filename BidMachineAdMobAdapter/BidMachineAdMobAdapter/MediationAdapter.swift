//
//  BaseAdapter.swift
//  BidMachineAdMobAdapter
//
//  Created by Ilia Lozhkin on 20.12.2022.
//

import Foundation
import BidMachine
import GoogleMobileAds
import BidMachineAdapterCore

@objc class MediationAdapter: NSObject, GADMediationAdapter {
    
    static func adapterVersion() -> GADVersionNumber {
        return GADVersionNumber.version(BidMachineAdapter.adapterVersionPath + ".0")
    }
    
    static func adSDKVersion() -> GADVersionNumber {
        return GADVersionNumber.version(BidMachineSdk.sdkVersion)
    }
    
    static func networkExtrasClass() -> GADAdNetworkExtras.Type? {
        nil
    }
    
    required override init() {
        
    }
}

@objc (BidMachineCustomEventBanner) class BannerAdapter: MediationAdapter {
    
    private var provider: BidMachineAdProvider<BidMachineBanner>?
    
    func loadBanner(for adConfiguration: GADMediationBannerAdConfiguration,
                    completionHandler: @escaping GADMediationBannerLoadCompletionHandler) {
     
        self.provider = BidMachineAdProvider(adConfiguration.adSize.size.format)
        self.provider?.loadAd(mediationParams: adConfiguration.credentials,
                              success: {
            let ad = BannerAd($0)
            ad.delegate = completionHandler(ad, nil)
        }, failure: {
            _ = completionHandler(nil, $0)
        })
    }
}

@objc (BidMachineCustomEventInterstitial) class InterstitialAdapter: MediationAdapter {
    
    private var provider: BidMachineAdProvider<BidMachineInterstitial>?
    
    func loadInterstitial(for adConfiguration: GADMediationInterstitialAdConfiguration,
                          completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler) {
     
        self.provider = BidMachineAdProvider(.interstitial)
        self.provider?.loadAd(mediationParams: adConfiguration.credentials,
                              success: {
            let ad = InterstitialAd($0)
            ad.delegate = completionHandler(ad, nil)
        }, failure: {
            _ = completionHandler(nil, $0)
        })
    }
}

@objc (BidMachineCustomEventRewarded) class RewardedAdapter: MediationAdapter {
    
    private var provider: BidMachineAdProvider<BidMachineRewarded>?
    
    func loadRewardedAd(for adConfiguration: GADMediationRewardedAdConfiguration,
                        completionHandler: @escaping GADMediationRewardedLoadCompletionHandler) {
     
        self.provider = BidMachineAdProvider(.rewarded)
        self.provider?.loadAd(mediationParams: adConfiguration.credentials,
                              success: {
            let ad = RewardedAd($0)
            ad.delegate = completionHandler(ad, nil)
        }, failure: {
            _ = completionHandler(nil, $0)
        })
    }
}

@objc (BidMachineCustomEventNativeAd) class NativeAdapter: MediationAdapter {
    
    private var provider: BidMachineAdProvider<BidMachineNative>?
    
    func loadNativeAd(for adConfiguration: GADMediationNativeAdConfiguration,
                      completionHandler: @escaping GADMediationNativeLoadCompletionHandler) {
     
        self.provider = BidMachineAdProvider(.native)
        self.provider?.loadAd(mediationParams: adConfiguration.credentials,
                              success: {
            let ad = NativeAd($0)
            ad.delegate = completionHandler(ad, nil)
        }, failure: {
            _ = completionHandler(nil, $0)
        })
    }
}
