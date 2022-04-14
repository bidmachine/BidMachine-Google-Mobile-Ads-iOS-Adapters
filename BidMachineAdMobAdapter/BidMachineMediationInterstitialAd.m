//
//  BidMachineMediationInterstitialAd.m
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 13.04.2022.
//  Copyright © 2022 Ilia Lozhkin. All rights reserved.
//

#import "BidMachineMediationInterstitialAd.h"
#include <stdatomic.h>

@import StackFoundation;


@interface BidMachineMediationInterstitialAd ()<BDMInterstitialDelegate>

@property (nonatomic, strong) BDMInterstitial *interstitial;
@property (nonatomic,   weak) id<GADMediationInterstitialAdEventDelegate> delegate;

@end

@implementation BidMachineMediationInterstitialAd {
    GADMediationInterstitialLoadCompletionHandler _loadCompletionHandler;
}

- (instancetype)initInterstitialWithConfiguration:(GADMediationInterstitialAdConfiguration *)adConfiguration
                                completionHandler:(GADMediationInterstitialLoadCompletionHandler)completionHandler {
    self = [super initInterstitialWithConfiguration:adConfiguration completionHandler:completionHandler];
    if (self) {
        __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
        __block GADMediationInterstitialLoadCompletionHandler originalCompletionHandler = [completionHandler copy];
        
        _loadCompletionHandler = ^id<GADMediationInterstitialAdEventDelegate>(_Nullable id<GADMediationInterstitialAd> ad, NSError *_Nullable error) {
          if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
          }

          id<GADMediationInterstitialAdEventDelegate> delegate = nil;
          if (originalCompletionHandler) {
            delegate = originalCompletionHandler(ad, error);
          }
          originalCompletionHandler = nil;

          return delegate;
        };
    }
    return self;
}

- (void)presentFromViewController:(UIViewController *)viewController {
    if (self.interstitial.canShow) {
        [self.interstitial presentFromRootViewController:viewController];
    } else {
        NSError *error = [STKError errorWithDescription:@"BidMachine rewarded ad can't show ad"];
        [self.delegate didFailToPresentWithError:error];
    }
}

#pragma mark - BDMExternalAdapterRequestControllerDelegate

- (void)controller:(nonnull BDMExternalAdapterRequestController *)controller didFailPrepareRequest:(nonnull NSError *)error {
    _loadCompletionHandler(nil, error);
}

- (void)controller:(nonnull BDMExternalAdapterRequestController *)controller didPrepareRequest:(nonnull BDMRequest *)request {
    BDMInterstitialRequest *adRequest = (BDMInterstitialRequest *)request;
    self.interstitial = [BDMInterstitial new];
    [self.interstitial setDelegate:self];
    [self.interstitial populateWithRequest:adRequest];
}

#pragma mark - BDMInterstitialDelegate

- (void)interstitialReadyToPresent:(nonnull BDMInterstitial *)interstitial {
    self.delegate = _loadCompletionHandler(self, nil);
}

- (void)interstitial:(nonnull BDMInterstitial *)interstitial failedWithError:(nonnull NSError *)error {
    _loadCompletionHandler(nil, error);
}

- (void)interstitial:(nonnull BDMInterstitial *)interstitial failedToPresentWithError:(nonnull NSError *)error {
    [self.delegate didFailToPresentWithError:error];
}

- (void)interstitialWillPresent:(nonnull BDMInterstitial *)interstitial {
    [self.delegate willPresentFullScreenView];
}

- (void)interstitialDidDismiss:(nonnull BDMInterstitial *)interstitial {
    [self.delegate willDismissFullScreenView];
    [self.delegate didDismissFullScreenView];
}

- (void)interstitialRecieveUserInteraction:(nonnull BDMInterstitial *)interstitial {
    [self.delegate reportClick];
}

@end
