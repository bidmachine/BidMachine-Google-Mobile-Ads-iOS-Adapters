//
//  BidMachineMediationNativeAd.m
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 13.04.2022.
//  Copyright © 2022 Ilia Lozhkin. All rights reserved.
//

#import "BidMachineMediationNativeAd.h"
#include <stdatomic.h>

@import StackFoundation;

@interface BidMachineMediationNativeAd ()<BDMNativeAdDelegate, BDMAdEventProducerDelegate>

@property (nonatomic,   weak) id<GADMediationNativeAdEventDelegate> delegate;

@end

@implementation BidMachineMediationNativeAd {
    GADMediationNativeLoadCompletionHandler _loadCompletionHandler;
}

- (instancetype)initNativeWithConfiguration:(GADMediationNativeAdConfiguration *)adConfiguration
                          completionHandler:(GADMediationNativeLoadCompletionHandler)completionHandler {
    self = [super initNativeWithConfiguration:adConfiguration completionHandler:completionHandler];
    if (self) {
        __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
        __block GADMediationNativeLoadCompletionHandler originalCompletionHandler = [completionHandler copy];
        
        _loadCompletionHandler = ^id<GADMediationNativeAdEventDelegate>(_Nullable id<GADMediationNativeAd> ad, NSError *_Nullable error) {
          if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
          }

          id<GADMediationNativeAdEventDelegate> delegate = nil;
          if (originalCompletionHandler) {
            delegate = originalCompletionHandler(ad, error);
          }
          originalCompletionHandler = nil;

          return delegate;
        };
    }
    return self;
}

- (BOOL)handlesUserClicks {
    return YES;
}

- (BOOL)handlesUserImpressions {
    return YES;
}

#pragma mark - BDMExternalAdapterRequestControllerDelegate

- (void)controller:(nonnull BDMExternalAdapterRequestController *)controller didFailPrepareRequest:(nonnull NSError *)error {
    _loadCompletionHandler(nil, error);
}

- (void)controller:(nonnull BDMExternalAdapterRequestController *)controller didPrepareRequest:(nonnull BDMRequest *)request {
    BDMNativeAdRequest *adRequest = (BDMNativeAdRequest *)request;
    self.nativeAd.delegate = self;
    self.nativeAd.producerDelegate = self;
    [self.nativeAd makeRequest:adRequest];
}

#pragma mark - BDMNativeAdDelegate

- (void)nativeAd:(nonnull BDMNativeAd *)nativeAd readyToPresentAd:(nonnull BDMAuctionInfo *)auctionInfo {
    self.delegate = _loadCompletionHandler(self, nil);
}

- (void)nativeAd:(nonnull BDMNativeAd *)nativeAd failedWithError:(nonnull NSError *)error {
    _loadCompletionHandler(nil, error);
}

#pragma mark - BDMAdEventProducerDelegate

- (void)didProduceUserAction:(nonnull id<BDMAdEventProducer>)producer {
    [self.delegate reportClick];
}

- (void)didProduceImpression:(nonnull id<BDMAdEventProducer>)producer {
    [self.delegate reportImpression];
}

@end
