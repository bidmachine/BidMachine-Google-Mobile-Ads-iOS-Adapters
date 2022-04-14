//
//  BidMachineMediationBannerAd.m
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 13.04.2022.
//  Copyright © 2022 Ilia Lozhkin. All rights reserved.
//

#import "BidMachineMediationBannerAd.h"
#include <stdatomic.h>

@interface BidMachineMediationBannerAd () <BDMBannerDelegate, BDMAdEventProducerDelegate>

@property(nonatomic, readwrite, nonnull) UIView *view;

@property (nonatomic, strong) BDMBannerView *bannerView;
@property (nonatomic,   weak) id<GADMediationBannerAdEventDelegate> delegate;

@end

@implementation BidMachineMediationBannerAd {
    GADMediationBannerLoadCompletionHandler _loadCompletionHandler;
}

- (instancetype)initBannerWithConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration
                          completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler {
    self = [super initBannerWithConfiguration:adConfiguration completionHandler:completionHandler];
    if (self) {
        __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
        __block GADMediationBannerLoadCompletionHandler originalCompletionHandler = [completionHandler copy];
        
        _loadCompletionHandler = ^id<GADMediationBannerAdEventDelegate>(_Nullable id<GADMediationBannerAd> ad, NSError *_Nullable error) {
          if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
          }

          id<GADMediationBannerAdEventDelegate> delegate = nil;
          if (originalCompletionHandler) {
            delegate = originalCompletionHandler(ad, error);
          }
          originalCompletionHandler = nil;

          return delegate;
        };
    }
    return self;
}

#pragma mark - BDMExternalAdapterRequestControllerDelegate

- (void)controller:(nonnull BDMExternalAdapterRequestController *)controller didFailPrepareRequest:(nonnull NSError *)error {
    _loadCompletionHandler(nil, error);
}

- (void)controller:(nonnull BDMExternalAdapterRequestController *)controller didPrepareRequest:(nonnull BDMRequest *)request {
    BDMBannerRequest *adRequest = (BDMBannerRequest *)request;
    
    self.bannerView = ({
        BDMBannerView *banner = [BDMBannerView new];
        banner.delegate = self;
        banner.producerDelegate = self;
        banner.frame = (CGRect){.size = CGSizeFromBDMSize(adRequest.adSize)};
        banner;
    });
    
    [self.bannerView populateWithRequest:adRequest];
}

#pragma mark - BDMBannerDelegate

- (void)bannerViewReadyToPresent:(nonnull BDMBannerView *)bannerView {
    self.view = bannerView;
    self.delegate = _loadCompletionHandler(self, nil);
}

- (void)bannerView:(nonnull BDMBannerView *)bannerView failedWithError:(nonnull NSError *)error {
    _loadCompletionHandler(nil, error);
}

- (void)bannerViewRecieveUserInteraction:(nonnull BDMBannerView *)bannerView {
    [self.delegate reportClick];
}


- (void)bannerViewWillPresentScreen:(nonnull BDMBannerView *)bannerView {
    [self.delegate willPresentFullScreenView];
}

- (void)bannerViewDidDismissScreen:(nonnull BDMBannerView *)bannerView {
    [self.delegate willDismissFullScreenView];
    [self.delegate didDismissFullScreenView];
}

#pragma mark - BDMAdEventProducerDelegate

- (void)didProduceUserAction:(nonnull id<BDMAdEventProducer>)producer {
    
}

- (void)didProduceImpression:(nonnull id<BDMAdEventProducer>)producer {
    [self.delegate reportImpression];
}

@end
