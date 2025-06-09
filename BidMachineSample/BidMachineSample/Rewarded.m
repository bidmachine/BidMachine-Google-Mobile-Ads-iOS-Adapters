//
//  Rewarded.m
//  AdMobBidMachineSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Rewarded.h"

#define UNIT_ID         "ca-app-pub-3940256099942544/1712485313"

@interface Rewarded ()<GADFullScreenContentDelegate>

@property (nonatomic, strong) GADRewardedAd *rewarded;
@end

@implementation Rewarded

- (void)loadAd:(id)sender {
    [self switchState:BSStateLoading];
    
    NSError *error = nil;
    BidMachinePlacement *placement = [[BidMachineSdk shared] placementFrom:BidMachinePlacementFormatRewarded error:&error builder:nil];
    if (!placement) {
        return;
    }

    BidMachineAuctionRequest *request = [[BidMachineSdk shared] auctionRequestWithPlacement:placement builder:nil];
    
    __weak typeof(self) weakSelf = self;
    [BidMachineSdk.shared rewardedWithRequest:request completion:^(BidMachineRewarded *ad, NSError *error) {
        [BDMAdMobAdapter store:ad];
        [weakSelf makeRequest];
    }];
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
