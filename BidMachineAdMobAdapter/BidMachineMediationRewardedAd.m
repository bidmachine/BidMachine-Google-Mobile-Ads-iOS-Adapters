//
//  BidMachineMediationRewardedAd.m
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 13.04.2022.
//  Copyright © 2022 Ilia Lozhkin. All rights reserved.
//

#import "BidMachineMediationRewardedAd.h"
#include <stdatomic.h>

@import StackFoundation;

@interface BidMachineMediationRewardedAd ()<BDMRewardedDelegate>

@property (nonatomic, strong) BDMRewarded *rewarded;
@property (nonatomic,   weak) id<GADMediationRewardedAdEventDelegate> delegate;

@end

@implementation BidMachineMediationRewardedAd {
    GADMediationRewardedLoadCompletionHandler _loadCompletionHandler;
}

- (instancetype)initRewardedWithConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                            completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {
    self = [super initRewardedWithConfiguration:adConfiguration completionHandler:completionHandler];
    if (self) {
        __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
        __block GADMediationRewardedLoadCompletionHandler originalCompletionHandler = [completionHandler copy];
        
        _loadCompletionHandler = ^id<GADMediationRewardedAdEventDelegate>(_Nullable id<GADMediationRewardedAd> ad, NSError *_Nullable error) {
          if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
          }

          id<GADMediationRewardedAdEventDelegate> delegate = nil;
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
    if (self.rewarded.canShow) {
        [self.rewarded presentFromRootViewController:viewController];
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
    BDMRewardedRequest *adRequest = (BDMRewardedRequest *)request;
    self.rewarded = [BDMRewarded new];
    [self.rewarded setDelegate:self];
    [self.rewarded populateWithRequest:adRequest];
}

#pragma mark - BDMRewardedDelegate

- (void)rewardedReadyToPresent:(nonnull BDMRewarded *)rewarded {
    self.delegate = _loadCompletionHandler(self, nil);
}

- (void)rewarded:(nonnull BDMRewarded *)rewarded failedWithError:(nonnull NSError *)error {
    _loadCompletionHandler(nil, error);
}

- (void)rewarded:(nonnull BDMRewarded *)rewarded failedToPresentWithError:(nonnull NSError *)error {
    [self.delegate didFailToPresentWithError:error];
}

- (void)rewardedWillPresent:(nonnull BDMRewarded *)rewarded {
    [self.delegate willPresentFullScreenView];
}

- (void)rewardedDidDismiss:(nonnull BDMRewarded *)rewarded {
    [self.delegate willDismissFullScreenView];
    [self.delegate didDismissFullScreenView];
}

- (void)rewardedRecieveUserInteraction:(nonnull BDMRewarded *)rewarded {
    [self.delegate reportClick];
}

- (void)rewardedFinishRewardAction:(nonnull BDMRewarded *)rewarded {
    [self.delegate didRewardUser];
}

@end
