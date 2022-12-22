//
//  Interstitial.m
//  AdMobBidMachineSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Interstitial.h"


#define UNIT_ID         "ca-app-pub-3216013768320747/4019430704"

@interface Interstitial () <GADFullScreenContentDelegate>

@property (nonatomic, strong) GADInterstitialAd *interstitial;

@end

@implementation Interstitial

- (void)loadAd:(id)sender {
    [self switchState:BSStateLoading];
    
    __weak typeof(self) weakSelf = self;
    [BidMachineSdk.shared interstitial:nil :^(BidMachineInterstitial *ad, NSError *error) {
        [BidMachineAdMobAdapter store:ad];
        [weakSelf makeRequest];
    }];
}

- (void)showAd:(id)sender {
    [self switchState:BSStateIdle];
    [self.interstitial presentFromRootViewController:self];
}

- (void)makeRequest {
    __weak typeof(self) weakSelf = self;
    
    GADRequest *request = [GADRequest request];
    [GADInterstitialAd loadWithAdUnitID:@UNIT_ID request:request completionHandler:^(GADInterstitialAd * _Nullable interstitialAd, NSError * _Nullable error) {
        if (error) {
            // fail load
            [weakSelf switchState:BSStateIdle];
        } else {
            [weakSelf switchState:BSStateReady];
            weakSelf.interstitial = interstitialAd;
            weakSelf.interstitial.fullScreenContentDelegate = self;
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
