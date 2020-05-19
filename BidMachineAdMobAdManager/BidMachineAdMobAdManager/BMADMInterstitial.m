//
//  BMADMInterstitial.m
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 5/15/20.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMADMInterstitial.h"
#import "BMADMFetcher.h"
#import <BidMachine/BidMachine.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

#define UNIT_ID         "/91759738/spacetour_interstitial_1"//"/91759738/interstitial"

@interface BMADMInterstitial()<BDMInterstitialDelegate, BDMRequestDelegate, GADInterstitialDelegate, GADAppEventDelegate>

@property (nonatomic, strong) BDMInterstitial *interstitial;
@property (nonatomic, strong) DFPInterstitial *adMobInterstitial;
@property (nonatomic, strong) BDMInterstitialRequest *interstitialRequest;

@end

@implementation BMADMInterstitial

- (void)loadAd {
    [self clean];
    [self.interstitialRequest performWithDelegate:self];
}

- (void)show:(UIViewController *)controller {
    [self.interstitial presentFromRootViewController:controller];
}

- (BOOL)isLoaded {
    return [self.interstitial isLoaded];
}

#pragma mark - Private

- (void)clean {
    self.interstitial = nil;
    self.adMobInterstitial = nil;
    self.interstitialRequest = nil;
}

- (BDMInterstitialRequest *)interstitialRequest {
    if (!_interstitialRequest) {
        _interstitialRequest = [BDMInterstitialRequest new];
    }
    return _interstitialRequest;
}

- (BDMInterstitial *)interstitial {
    if (!_interstitial) {
        _interstitial = [BDMInterstitial new];
        _interstitial.delegate = self;
    }
    return _interstitial;
}

- (DFPInterstitial *)adMobInterstitial {
    if (!_adMobInterstitial) {
        _adMobInterstitial = [[DFPInterstitial alloc] initWithAdUnitID:@UNIT_ID];
        _adMobInterstitial.delegate = self;
        _adMobInterstitial.appEventDelegate = self;
    }
    return _adMobInterstitial;
}

#pragma mark - BDMInterstitialDelegate

- (void)interstitial:(nonnull BDMInterstitial *)interstitial failedToPresentWithError:(nonnull NSError *)error {
    [self.delegate onAdFailToPresent];
}

- (void)interstitial:(nonnull BDMInterstitial *)interstitial failedWithError:(nonnull NSError *)error {
    [self.delegate onAdFailToLoad];
}

- (void)interstitialDidDismiss:(nonnull BDMInterstitial *)interstitial {
    [self.delegate onAdClosed];
}

- (void)interstitialReadyToPresent:(nonnull BDMInterstitial *)interstitial {
    [self.delegate onAdLoaded];
}

- (void)interstitialRecieveUserInteraction:(nonnull BDMInterstitial *)interstitial {
    [self.delegate onAdClicked];
}

- (void)interstitialWillPresent:(nonnull BDMInterstitial *)interstitial {
    [self.delegate onAdShown];
}

- (void)interstitialDidExpire:(nonnull BDMInterstitial *)interstitial {
    [self.delegate onAdExpired];
}

#pragma mark - BDMRequestDelegate

- (void)request:(nonnull BDMRequest *)request completeWithInfo:(nonnull BDMAuctionInfo *)info {
    if (info.price.doubleValue <= 10) {
        [BMADMFetcher.shared setFormat:@"1.0"];
    } else {
        [BMADMFetcher.shared setFormat:@"1000.0"];
    }
    
    DFPRequest *adMobRequest = [DFPRequest request];
    adMobRequest.customTargeting = [BMADMFetcher.shared fetchParamsFromRequest:self.interstitialRequest];
    [self.adMobInterstitial loadRequest:adMobRequest];
}

- (void)request:(nonnull BDMRequest *)request failedWithError:(nonnull NSError *)error {
    [self.delegate onAdFailToLoad];
}

- (void)requestDidExpire:(nonnull BDMRequest *)request {
    [self.delegate onAdExpired];
}

#pragma mark - GADInterstitialDelegate

- (void)didFailToReceiveAdWithError:(nonnull GADRequestError *)error {
    [self.delegate onAdFailToLoad];
}

- (void)interstitial:(nonnull DFPInterstitial *)interstitial
  didReceiveAppEvent:(nonnull NSString *)name
            withInfo:(nullable NSString *)info {
    [self.interstitial populateWithRequest:self.interstitialRequest];
}

@end
