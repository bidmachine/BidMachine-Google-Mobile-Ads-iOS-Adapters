//
//  BidMachineMediationAdapter.h
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 13.04.2022.
//  Copyright © 2022 Ilia Lozhkin. All rights reserved.
//

#import <BidMachine/BidMachine.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <BidMachine/BDMExternalAdapterRequestController.h>

@interface BidMachineMediationAdapter : NSObject <BDMExternalAdapterRequestControllerDelegate>

- (instancetype)initBannerWithConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration
                          completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler;

- (instancetype)initInterstitialWithConfiguration:(GADMediationInterstitialAdConfiguration *)adConfiguration
                          completionHandler:(GADMediationInterstitialLoadCompletionHandler)completionHandler;

- (instancetype)initRewardedWithConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                          completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler;

- (instancetype)initNativeWithConfiguration:(GADMediationNativeAdConfiguration *)adConfiguration
                          completionHandler:(GADMediationNativeLoadCompletionHandler)completionHandler;

- (void)loadAd;

@end
