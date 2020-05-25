//
//  BMADMInterstitialAd.m
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 25.05.2020.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMADMInterstitialAd.h"
#import "BMADMFetcher.h"
#import "BMADMNetworkEvent.h"
#import <BidMachine/BidMachine.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface BMADMInterstitialAd()<BDMInterstitialDelegate, BDMRequestDelegate, GADInterstitialDelegate, GADAppEventDelegate>

@property (nonatomic, strong) BDMInterstitial *interstitial;
@property (nonatomic, strong) DFPInterstitial *adMobInterstitial;
@property (nonatomic, strong) BDMInterstitialRequest *interstitialRequest;
@property (nonatomic, strong) NSString *unitId;
@property (nonatomic, strong) BMADMNetworkEvent *event;

@end

@implementation BMADMInterstitialAd

- (instancetype)initWithUnitId:(NSString *)unitId {
    if (self = [super init]) {
        _unitId = unitId;
    }
    return self;
}

- (void)loadAd {
    [self clean];
    self.event.request = self.interstitialRequest;
    [self.interstitialRequest performWithDelegate:self];
    [self.event trackEvent:BMADMEventBMRequestStart customParams:nil];
}

- (void)show:(UIViewController *)controller {
    [self.event trackEvent:BMADMEventBMShow customParams:nil];
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
    self.event = nil;
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
        _adMobInterstitial = [[DFPInterstitial alloc] initWithAdUnitID:self.unitId];
        _adMobInterstitial.delegate = self;
        _adMobInterstitial.appEventDelegate = self;
    }
    return _adMobInterstitial;
}

- (BMADMNetworkEvent *)event {
    if (!_event) {
        _event = BMADMNetworkEvent.new;
        _event.adType = BMADMEventTypeInterstitial;
    }
    return _event;
}

#pragma mark - BDMInterstitialDelegate

- (void)interstitial:(nonnull BDMInterstitial *)interstitial failedToPresentWithError:(nonnull NSError *)error {
    [self.event trackError:error event:BMADMEventBMFailToShow customParams:nil internal:NO];
    [self.delegate onAdFailToPresent];
}

- (void)interstitial:(nonnull BDMInterstitial *)interstitial failedWithError:(nonnull NSError *)error {
    [self.event trackError:error event:BMADMEventBMFailToLoad customParams:nil internal:NO];
    [self.delegate onAdFailToLoad];
}

- (void)interstitialDidDismiss:(nonnull BDMInterstitial *)interstitial {
    [self.event trackEvent:BMADMEventBMClosed customParams:nil];
    [self.delegate onAdClosed];
}

- (void)interstitialReadyToPresent:(nonnull BDMInterstitial *)interstitial {
    [self.event trackEvent:BMADMEventBMLoaded customParams:nil];
    [self.delegate onAdLoaded];
}

- (void)interstitialRecieveUserInteraction:(nonnull BDMInterstitial *)interstitial {
    [self.event trackEvent:BMADMEventBMClicked customParams:nil];
    [self.delegate onAdClicked];
}

- (void)interstitialWillPresent:(nonnull BDMInterstitial *)interstitial {
    [self.event trackEvent:BMADMEventBMShown customParams:nil];
    [self.delegate onAdShown];
}

- (void)interstitialDidExpire:(nonnull BDMInterstitial *)interstitial {
    [self.event trackEvent:BMADMEventBMExpired customParams:nil];
    [self.delegate onAdExpired];
}

#pragma mark - BDMRequestDelegate

- (void)request:(nonnull BDMRequest *)request completeWithInfo:(nonnull BDMAuctionInfo *)info {
    [self.event trackEvent:BMADMEventBMRequestSuccess customParams:nil];
    if (info.price.doubleValue <= 10) {
        [BMADMFetcher.shared setFormat:@"1.0"];
    } else {
        [BMADMFetcher.shared setFormat:@"1000.0"];
    }
    
    DFPRequest *adMobRequest = [DFPRequest request];
    adMobRequest.customTargeting = [BMADMFetcher.shared fetchParamsFromRequest:self.interstitialRequest];
    
    [self.event trackEvent:BMADMEventGAMLoadStart customParams:adMobRequest.customTargeting];
    [self.adMobInterstitial loadRequest:adMobRequest];
}

- (void)request:(nonnull BDMRequest *)request failedWithError:(nonnull NSError *)error {
    [self.event trackError:error event:BMADMEventBMRequestFail customParams:nil internal:NO];
    [self.delegate onAdFailToLoad];
}

- (void)requestDidExpire:(nonnull BDMRequest *)request {
    [self.event trackEvent:BMADMEventBMExpired customParams:nil];
    [self.delegate onAdExpired];
}

#pragma mark - GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(nonnull GADInterstitial *)ad {
    [self.event trackEvent:BMADMEventGAMLoaded customParams:nil];
}

- (void)didFailToReceiveAdWithError:(nonnull GADRequestError *)error {
    [self.event trackError:error event:BMADMEventGAMFailToLoad customParams:nil internal:YES];
    [self.delegate onAdFailToLoad];
}

- (void)interstitial:(nonnull DFPInterstitial *)interstitial
  didReceiveAppEvent:(nonnull NSString *)name
            withInfo:(nullable NSString *)info {
    NSMutableDictionary *customInfo = NSMutableDictionary.new;
    customInfo[@"app_event_key"] = name;
    customInfo[@"app_event_value"] = info;
    [self.event trackEvent:BMADMEventGAMAppEvent customParams:customInfo];
    [self.event trackEvent:BMADMEventBMLoadStart customParams:nil];
    [self.interstitial populateWithRequest:self.interstitialRequest];
}

@end
