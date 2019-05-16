//
//  GADMBidMachineInterstitialAd.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/15/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADMBidMachineInterstitialAd.h"
#import "GADBidMachineUtils+Request.h"
#import <BidMachine/BidMachine.h>

@interface GADMBidMachineInterstitialAd() <BDMInterstitialDelegate>

@property (nonatomic, strong) BDMInterstitial *interstitial;

@end

@implementation GADMBidMachineInterstitialAd

- (void)requestInterstitialAdWithParameter:(nullable NSString *)serverParameter
                                     label:(nullable NSString *)serverLabel
                                   request:(nonnull GADCustomEventRequest *)request {
    [[GADBidMachineUtils sharedUtils] initializeBidMachineWith:serverParameter request:request];
    self.interstitial.delegate = self;
    BDMInterstitialRequest *interstitialRequest = [[GADBidMachineUtils sharedUtils] interstitialRequestWithServerParameter:serverParameter request:request];
    [self.interstitial populateWithRequest:interstitialRequest];
}

- (void)presentFromRootViewController:(nonnull UIViewController *)rootViewController {
    if ([self.interstitial isLoaded]) {
        [self.interstitial presentFromRootViewController:rootViewController];
    }
}

#pragma mark - Lazy

- (BDMInterstitial *)interstitial {
    if (!_interstitial) {
        _interstitial = [BDMInterstitial new];
    }
    return _interstitial;
}

#pragma mark - BDMInterstitialDelegate

- (void)interstitialReadyToPresent:(nonnull BDMInterstitial *)interstitial {
    [self.delegate customEventInterstitialDidReceiveAd:self];
}

- (void)interstitial:(nonnull BDMInterstitial *)interstitial failedWithError:(nonnull NSError *)error {
    [self.delegate customEventInterstitial:self didFailAd:error];
}

- (void)interstitialWillPresent:(nonnull BDMInterstitial *)interstitial {
    [self.delegate customEventInterstitialWillPresent:self];
}

- (void)interstitial:(nonnull BDMInterstitial *)interstitial failedToPresentWithError:(nonnull NSError *)error {
    
}

- (void)interstitialDidDismiss:(nonnull BDMInterstitial *)interstitial {
    [self.delegate customEventInterstitialDidDismiss:self];
}

- (void)interstitialRecieveUserInteraction:(nonnull BDMInterstitial *)interstitial {
    [self.delegate customEventInterstitialWasClicked:self];
}

@end
