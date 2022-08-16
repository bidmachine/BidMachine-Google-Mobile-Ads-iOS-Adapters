//
//  Rewarded.m
//  AdMobBidMachineSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Rewarded.h"

#define UNIT_ID         "ca-app-pub-3216013768320747/1325926558"

@interface Rewarded ()<BDMRequestDelegate, GADFullScreenContentDelegate>

@property (nonatomic, strong) GADRewardedAd *rewarded;
@property (nonatomic, strong) BDMRewardedRequest *request;

@end

@implementation Rewarded

- (void)loadAd:(id)sender {
    [self switchState:BSStateLoading];
    self.request = [BDMRewardedRequest new];
    [self.request performWithDelegate:self];
}

- (void)showAd:(id)sender {
    [self switchState:BSStateIdle];
    [self.rewarded presentFromRootViewController:self userDidEarnRewardHandler:^{
        //reward
    }];
}

- (void)makeRequest {
    __weak typeof(self) weakSelf = self;
    
    GADRequest *request = [GADRequest request];
    [GADRewardedAd loadWithAdUnitID:@UNIT_ID request:request completionHandler:^(GADRewardedAd * _Nullable rewardedAd, NSError * _Nullable error) {
        if (error) {
            // fail load
            [weakSelf switchState:BSStateIdle];
        } else {
            self.rewarded = rewardedAd;
            self.rewarded.fullScreenContentDelegate = self;
            [weakSelf switchState:BSStateReady];
        }
    }];
}

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithAd:(id<BDMAdProtocol>)adObject {
    // After request complete loading application can lost strong ref on it
    // BDMRequestStorage will capture request by itself
    self.request = nil;
    // Save request for bid
    [BDMRequestStorage.shared saveRequest:request];
    // Here we define which Admob ad should be loaded
    [self makeRequest];
}

- (void)request:(BDMRequest *)request failedWithError:(NSError *)error {
    // In case request failed we can release it
    // and build some retry logic
    self.request = nil;
    [self switchState:BSStateIdle];
}

- (void)request:(BDMRequest *)request didExpireAd:(id<BDMAdProtocol>)adObject {
    // In case request expired we can release it
    // and build some retry logic
}

#pragma mark - GADFullScreenContentDelegate

- (void)adDidRecordImpression:(nonnull id<GADFullScreenPresentingAd>)ad {
    
}

- (void)adDidRecordClick:(nonnull id<GADFullScreenPresentingAd>)ad {
    
}

- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    
}

- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    
}

- (void)adWillDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    
}

- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    
}

@end
