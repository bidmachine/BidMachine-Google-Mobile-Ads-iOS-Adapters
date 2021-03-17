//
//  Interstitial.m
//  AdMobBidMachineSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Interstitial.h"


#define UNIT_ID         "ca-app-pub-3216013768320747/4019430704"
#define EXTRAS_MARK     "BMInterstitialCustomEvent_0.2"

@interface Interstitial ()<BDMRequestDelegate, GADFullScreenContentDelegate>

@property (nonatomic, strong) GADInterstitialAd *interstitial;
@property (nonatomic, strong) BDMInterstitialRequest *request;

@end

@implementation Interstitial

- (void)loadAd:(id)sender {
    self.request = [BDMInterstitialRequest new];
    [self.request performWithDelegate:self];
}

- (void)showAd:(id)sender {
    [self.interstitial presentFromRootViewController:self];
}

- (void)makeRequest {
    GADRequest *request = [GADRequest request];
    [GADInterstitialAd loadWithAdUnitID:@UNIT_ID request:request completionHandler:^(GADInterstitialAd * _Nullable interstitialAd, NSError * _Nullable error) {
        if (error) {
            // fail load
        } else {
            self.interstitial = interstitialAd;
            self.interstitial.fullScreenContentDelegate = self;
        }
    }];
}

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BDMRequestStorage will capture request by itself
    self.request = nil;
    // Save request for bid
    [BDMFetcher.shared fetchParamsFromRequest:request];
    // Here we define which Admob ad should be loaded
    [self makeRequest];
}

- (void)request:(BDMRequest *)request failedWithError:(NSError *)error {
    // In case request failed we can release it
    // and build some retry logic
    self.request = nil;
}

- (void)requestDidExpire:(BDMRequest *)request {
    // In case request expired we can release it
    // and build some retry logic
}

#pragma mark - GADFullScreenContentDelegate

- (void)adDidRecordImpression:(nonnull id<GADFullScreenPresentingAd>)ad {
    
}

- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    
}

- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    
}

- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    
}

@end
