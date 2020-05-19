//
//  BMADMBannerView.m
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 5/18/20.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMADMBannerView.h"
#import "BMADMFetcher.h"
#import <BidMachine/BidMachine.h>
#import <StackUIKit/StackUIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

#define UNIT_ID         "/91759738/spacetour_banner_1"

@interface BMADMBannerView ()<BDMBannerDelegate, BDMRequestDelegate, GADBannerViewDelegate, GADAppEventDelegate>

@property (nonatomic, strong) BDMBannerView *banner;
@property (nonatomic, strong) DFPBannerView *adMobBanner;
@property (nonatomic, strong) BDMBannerRequest *bannerRequest;

@end

@implementation BMADMBannerView

- (void)loadAd {
    [self clean];
    [self.bannerRequest performWithDelegate:self];
}

- (void)show:(UIViewController *)controller {
    if (!self.banner.superview) {
        self.banner.rootViewController = controller;
        [self.banner stk_edgesEqual:self];
        [self addSubview:self.banner];
    }
}

- (BOOL)isLoaded {
    return [self.banner isLoaded];
}

#pragma mark - Private

- (void)clean {
    self.banner = nil;
    self.adMobBanner = nil;
    self.bannerRequest = nil;
}

- (BDMBannerRequest *)bannerRequest {
    if (!_bannerRequest) {
        _bannerRequest = [BDMBannerRequest new];
    }
    return _bannerRequest;
}

- (BDMBannerView *)banner {
    if (!_banner) {
        _banner = [BDMBannerView new];
        _banner.delegate = self;
    }
    return _banner;
}

- (DFPBannerView *)adMobBanner {
    if (!_adMobBanner) {
        _adMobBanner = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        _adMobBanner.delegate = self;
        _adMobBanner.adUnitID = @UNIT_ID;
        _adMobBanner.rootViewController = [[UIApplication.sharedApplication keyWindow] rootViewController];
        _adMobBanner.appEventDelegate = self;
    }
    return _adMobBanner;
}

#pragma mark - BDMBannerDelegate

- (void)bannerViewReadyToPresent:(nonnull BDMBannerView *)bannerView {
    [self.delegate onAdLoaded];
}

- (void)bannerView:(nonnull BDMBannerView *)bannerView failedWithError:(nonnull NSError *)error {
    [self.delegate onAdFailToLoad];
}

- (void)bannerViewRecieveUserInteraction:(nonnull BDMBannerView *)bannerView {
    [self.delegate onAdClicked];
}

- (void)bannerViewDidExpire:(nonnull BDMBannerView *)bannerView {
    [self.delegate onAdExpired];
}

- (void)bannerViewWillPresentScreen:(nonnull BDMBannerView *)bannerView {
    [self.delegate onAdShown];
}

- (void)bannerViewDidDismissScreen:(nonnull BDMBannerView *)bannerView {
    [self.delegate onAdClosed];
}

#pragma mark - BDMRequestDelegate

- (void)request:(nonnull BDMRequest *)request failedWithError:(nonnull NSError *)error {
    [self.delegate onAdFailToLoad];
}

- (void)request:(nonnull BDMRequest *)request completeWithInfo:(nonnull BDMAuctionInfo *)info {
    if (info.price.doubleValue <= 1) {
        [BMADMFetcher.shared setFormat:@"0.2"];
    } else {
        [BMADMFetcher.shared setFormat:@"1000.0"];
    }
    DFPRequest *adMobRequest = [DFPRequest request];
    adMobRequest.customTargeting = [BMADMFetcher.shared fetchParamsFromRequest:self.bannerRequest];
    [self.adMobBanner loadRequest:adMobRequest];
}

- (void)requestDidExpire:(nonnull BDMRequest *)request {
    [self.delegate onAdExpired];
}

#pragma mark - GADBannerViewDelegate

- (void)adView:(nonnull GADBannerView *)bannerView
didFailToReceiveAdWithError:(nonnull GADRequestError *)error {
    [self.delegate onAdFailToLoad];
}

- (void)adView:(nonnull GADBannerView *)banner
didReceiveAppEvent:(nonnull NSString *)name
      withInfo:(nullable NSString *)info {
    [self.banner populateWithRequest:self.bannerRequest];
}

@end
