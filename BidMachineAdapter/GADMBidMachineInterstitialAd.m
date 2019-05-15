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

@interface GADMBidMachineInterstitialAd()

@property (nonatomic, strong) BDMInterstitial *interstitial;
@property (nonatomic, weak) id<GADMAdNetworkConnector> connector;
@property (nonatomic, weak) id<GADMAdNetworkAdapter> adapter;

@end

@implementation GADMBidMachineInterstitialAd

- (void)requestInterstitialAdWithParameter:(nullable NSString *)serverParameter
                                     label:(nullable NSString *)serverLabel
                                   request:(nonnull GADCustomEventRequest *)request {
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

@synthesize delegate;


@end
