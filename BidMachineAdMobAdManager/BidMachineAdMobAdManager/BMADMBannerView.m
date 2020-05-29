//
//  BMADMBannerView.m
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 5/18/20.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMADMBannerView.h"
#import "BMADMFetcher.h"
#import "BMADMNetworkEvent.h"
#import <BidMachine/BidMachine.h>
#import <StackUIKit/StackUIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface BMADMBannerView ()<BDMBannerDelegate, BDMRequestDelegate, GADBannerViewDelegate, GADAppEventDelegate, BDMAdEventProducerDelegate>

@property (nonatomic, strong) BDMBannerView *banner;
@property (nonatomic, strong) DFPBannerView *adMobBanner;
@property (nonatomic, strong) BDMBannerRequest *bannerRequest;
@property (nonatomic, strong) BMADMNetworkEvent *event;

@end

@implementation BMADMBannerView

- (void)loadAd {
    [self clean];
    self.event.request = self.bannerRequest;
    [self.bannerRequest performWithDelegate:self];
}

- (void)show:(UIViewController *)controller {
    if (!self.banner.superview) {
        [self.event trackEvent:BMADMEventBMShow customParams:nil];
        self.banner.rootViewController = controller;
        [self.banner stk_edgesEqual:self];
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
        _banner.producerDelegate = self;
    }
    return _banner;
}

- (DFPBannerView *)adMobBanner {
    if (!_adMobBanner) {
        _adMobBanner = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        _adMobBanner.delegate = self;
        _adMobBanner.adUnitID = self.unitId;
        _adMobBanner.rootViewController = [[UIApplication.sharedApplication keyWindow] rootViewController];
        _adMobBanner.appEventDelegate = self;
    }
    return _adMobBanner;
}

- (BMADMNetworkEvent *)event {
    if (!_event) {
        _event = BMADMNetworkEvent.new;
        _event.adType = BMADMEventTypeBanner;
    }
    return _event;
}

#pragma mark - BDMBannerDelegate

- (void)bannerViewReadyToPresent:(nonnull BDMBannerView *)bannerView {
    [self.event trackEvent:BMADMEventBMLoaded customParams:nil];
    [self.delegate onAdLoaded];
}

- (void)bannerView:(nonnull BDMBannerView *)bannerView failedWithError:(nonnull NSError *)error {
    [self.event trackError:error event:BMADMEventBMFailToLoad customParams:nil internal:NO];
    [self.delegate onAdFailToLoad];
}

- (void)bannerViewRecieveUserInteraction:(nonnull BDMBannerView *)bannerView {
    [self.event trackEvent:BMADMEventBMClicked customParams:nil];
    [self.delegate onAdClicked];
}

- (void)bannerViewDidExpire:(nonnull BDMBannerView *)bannerView {
    [self.event trackEvent:BMADMEventBMExpired customParams:nil];
    [self.delegate onAdExpired];
}

- (void)bannerViewWillPresentScreen:(nonnull BDMBannerView *)bannerView {

}

- (void)bannerViewDidDismissScreen:(nonnull BDMBannerView *)bannerView {
//    [self.event trackEvent:BMADMEventBMClosed customParams:nil];
//    [self.delegate onAdClosed];
}

- (void)didProduceImpression:(nonnull id<BDMAdEventProducer>)producer {
    [self.event trackEvent:BMADMEventBMShown customParams:nil];
    [self.delegate onAdShown];
}

- (void)didProduceUserAction:(nonnull id<BDMAdEventProducer>)producer {
    
}

#pragma mark - BDMRequestDelegate

- (void)request:(nonnull BDMRequest *)request failedWithError:(nonnull NSError *)error {
    [self.event trackError:error event:BMADMEventBMRequestFail customParams:nil internal:NO];
    [self.delegate onAdFailToLoad];
}

- (void)request:(nonnull BDMRequest *)request completeWithInfo:(nonnull BDMAuctionInfo *)info {
    [self.event trackEvent:BMADMEventBMRequestSuccess customParams:nil];
    if (info.price.doubleValue <= 1) {
        [BMADMFetcher.shared setFormat:@"0.2"];
    } else {
        [BMADMFetcher.shared setFormat:@"1000.0"];
    }
    DFPRequest *adMobRequest = [DFPRequest request];
    adMobRequest.customTargeting = [BMADMFetcher.shared fetchParamsFromRequest:self.bannerRequest];
    [self.event trackEvent:BMADMEventGAMLoadStart customParams:adMobRequest.customTargeting];
    [self.adMobBanner loadRequest:adMobRequest];
}

- (void)requestDidExpire:(nonnull BDMRequest *)request {
    [self.event trackEvent:BMADMEventBMExpired customParams:nil];
    [self.delegate onAdExpired];
}

#pragma mark - GADBannerViewDelegate

- (void)adViewDidReceiveAd:(nonnull GADBannerView *)bannerView {
    [self.event trackEvent:BMADMEventGAMLoaded customParams:nil];
}

- (void)adView:(nonnull GADBannerView *)bannerView
didFailToReceiveAdWithError:(nonnull GADRequestError *)error {
    [self.event trackError:error event:BMADMEventGAMFailToLoad customParams:nil internal:YES];
    [self.delegate onAdFailToLoad];
}

- (void)adView:(nonnull GADBannerView *)banner
didReceiveAppEvent:(nonnull NSString *)name
      withInfo:(nullable NSString *)info {
    NSMutableDictionary *customInfo = NSMutableDictionary.new;
    customInfo[@"app_event_key"] = name;
    customInfo[@"app_event_value"] = info;
    [self.event trackEvent:BMADMEventGAMAppEvent customParams:customInfo];
    [self.event trackEvent:BMADMEventBMLoadStart customParams:nil];
    [self.banner populateWithRequest:self.bannerRequest];
}

@end
