//
//  BidMachineCustomEventAdapter.m
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 13.04.2022.
//  Copyright © 2022 Ilia Lozhkin. All rights reserved.
//

#import "BidMachineCustomEventAdapter.h"
#import "BidMachineMediationBannerAd.h"
#import "BidMachineMediationInterstitialAd.h"
#import "BidMachineMediationRewardedAd.h"
#import "BidMachineMediationNativeAd.h"

@import BidMachine;
@import StackFoundation;
@import BidMachine.ExternalAdapterUtils;

@interface BidMachineCustomEventBanner () { BidMachineMediationBannerAd *_bannerAd; } @end
@interface BidMachineCustomEventInterstitial () { BidMachineMediationInterstitialAd *_interstitialAd; } @end
@interface BidMachineCustomEventRewarded () { BidMachineMediationRewardedAd *_rewardedAd; } @end
@interface BidMachineCustomEventNativeAd () { BidMachineMediationNativeAd *_nativeAd; } @end

@implementation BidMachineCustomEventAdapter

+ (GADVersionNumber)adSDKVersion {
    return [self versionFromBidMachineString:kBDMVersion];
}

+ (GADVersionNumber)adapterVersion {
    return [self versionFromBidMachineString:@"1.9.4.0"];
}

+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass {
    return nil;
}

+ (void)setUpWithConfiguration:(nonnull GADMediationServerConfiguration *)configuration
             completionHandler:(nonnull GADMediationAdapterSetUpCompletionBlock)completionHandler {
    completionHandler(nil);
}


+ (GADVersionNumber)versionFromBidMachineString:(NSString *)version {
    GADVersionNumber gadVersion = {0};
    NSArray<NSString *> *components = [version componentsSeparatedByString:@"."];
    if (components.count == 3) {
        gadVersion.majorVersion = components[0].integerValue;
        gadVersion.minorVersion = components[1].integerValue;
        gadVersion.patchVersion = components[2].integerValue;
    }
    return gadVersion;
}

@end

@implementation BidMachineCustomEventBanner

- (void)loadBannerForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration
                   completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler {
    _bannerAd = [[BidMachineMediationBannerAd alloc] initBannerWithConfiguration:adConfiguration completionHandler:completionHandler];
    [_bannerAd loadAd];
}

@end

@implementation BidMachineCustomEventInterstitial

- (void)loadInterstitialForAdConfiguration:(GADMediationInterstitialAdConfiguration *)adConfiguration
                         completionHandler:(GADMediationInterstitialLoadCompletionHandler)completionHandler {
    _interstitialAd = [[BidMachineMediationInterstitialAd alloc] initInterstitialWithConfiguration:adConfiguration completionHandler:completionHandler];
    [_interstitialAd loadAd];
}

@end

@implementation BidMachineCustomEventRewarded

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {
    _rewardedAd = [[BidMachineMediationRewardedAd alloc] initRewardedWithConfiguration:adConfiguration completionHandler:completionHandler];
    [_rewardedAd loadAd];
}

@end

@implementation BidMachineCustomEventNativeAd

- (void)loadNativeAdForAdConfiguration:(GADMediationNativeAdConfiguration *)adConfiguration
                     completionHandler:(GADMediationNativeLoadCompletionHandler)completionHandler {
    _nativeAd = [[BidMachineMediationNativeAd alloc] initNativeWithConfiguration:adConfiguration completionHandler:completionHandler];
    [_nativeAd loadAd];
}

@end
