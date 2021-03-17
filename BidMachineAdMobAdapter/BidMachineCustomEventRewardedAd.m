//
//  BidMachineCustomEventRewardedAd.m
//  AdMobBidMachineHBSample
//
//  Created by Ilia Lozhkin on 23.07.2020.
//  Copyright © 2020 Ilia Lozhkin. All rights reserved.
//

#import "BidMachineCustomEventRewardedAd.h"
#include <stdatomic.h>

@import BidMachine;
@import StackFoundation;

#import "BDMExternalAdapterRequestController.h"


@interface BidMachineCustomEventRewardedAd () <BDMRewardedDelegate, BDMExternalAdapterRequestControllerDelegate> {
    /// Handle rewarded ads from Sample SDK.
    BDMRewarded *_rewardedAd;
    
    BDMExternalAdapterRequestController *_requestController;
    
    /// Completion handler to call when sample rewarded ad finishes loading.
    GADMediationRewardedLoadCompletionHandler _loadCompletionHandler;
    
    ///  Delegate for receiving rewarded ad notifications.
    __weak id<GADMediationRewardedAdEventDelegate> _delegate;
    
    /// Configuraton
    GADMediationRewardedAdConfiguration *_adConfiguration;
}

@end


@implementation BidMachineCustomEventRewardedAd

- (instancetype)initWithConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {
    if (self = [super init]) {
        __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
        __block GADMediationRewardedLoadCompletionHandler originalCompletionHandler =
            [completionHandler copy];

        _loadCompletionHandler = ^id<GADMediationRewardedAdEventDelegate>(
            _Nullable id<GADMediationRewardedAd> ad, NSError *_Nullable error) {
          // Only allow completion handler to be called once.
          if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
          }

          id<GADMediationRewardedAdEventDelegate> delegate = nil;
          if (originalCompletionHandler) {
            // Call original handler and hold on to its return value.
            delegate = originalCompletionHandler(ad, error);
          }

          // Release reference to handler. Objects retained by the handler will also be released.
          originalCompletionHandler = nil;

          return delegate;
        };
        
        _adConfiguration = adConfiguration;
    }
    return self;
}

- (void)loadRewardedVideo {
    NSDictionary *extraInfo = [self extraInfoFromConfiguration:_adConfiguration];
    
    _requestController = [[BDMExternalAdapterRequestController alloc] initWithType:BDMInternalPlacementTypeRewardedVideo
                                                                          delegate:self];
    
    [_requestController prepareRequestWithConfiguration:[BDMExternalAdapterConfiguration configurationWithBuilder:^(id<BDMExternalAdapterConfigurationBuilderProtocol> builder) {
            builder.appendJsonConfiguration(extraInfo);
        }]];
}

- (void)presentFromViewController:(UIViewController *)viewController {
    if (_rewardedAd.canShow) {
        [_rewardedAd presentFromRootViewController:viewController];
    } else {
        id<GADMediationRewardedAdEventDelegate> strongDelegate = _delegate;
        NSError *error = [STKError errorWithDescription:@"BidMachine rewarded ad can't show ad"];
        [strongDelegate didFailToPresentWithError:error];
    }
}

#pragma mark - Private

- (NSDictionary *)extraInfoFromConfiguration:(GADMediationRewardedAdConfiguration *)configuration {
    NSMutableDictionary *requestInfo = [NSMutableDictionary new];
    NSString *parameters = ANY(configuration.credentials.settings).from(@"parameter").string;
    if (parameters) {
        NSDictionary *params = [STKJSONSerialization JSONObjectWithData:[parameters dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:NSJSONReadingAllowFragments
                                                                  error:nil];;
        [requestInfo addEntriesFromDictionary:params ?: @{}];
    }
    return requestInfo;
}

#pragma mark - BDMExternalAdapterRequestControllerDelegate

- (void)controller:(BDMExternalAdapterRequestController *)controller didPrepareRequest:(BDMRequest *)request {
    BDMRewardedRequest *adRequest = (BDMRewardedRequest *)request;
    _rewardedAd = [BDMRewarded new];
    [_rewardedAd setDelegate:self];
    [_rewardedAd populateWithRequest:adRequest];
}

- (void)controller:(BDMExternalAdapterRequestController *)controller didFailPrepareRequest:(NSError *)error {
    _loadCompletionHandler(nil, error);
}

#pragma mark - BDMRewardedDelegatge

- (void)rewardedReadyToPresent:(BDMRewarded *)rewarded {
    _delegate = _loadCompletionHandler(self, nil);
}

- (void)rewarded:(BDMRewarded *)rewarded failedWithError:(NSError *)error {
    _loadCompletionHandler(nil, error);
}

- (void)rewardedRecieveUserInteraction:(BDMRewarded *)rewarded {
    id<GADMediationRewardedAdEventDelegate> strongDelegate = _delegate;
    [strongDelegate reportClick];
}

- (void)rewarded:(BDMRewarded *)rewarded failedToPresentWithError:(NSError *)error {
    id<GADMediationRewardedAdEventDelegate> strongDelegate = _delegate;
    [strongDelegate didFailToPresentWithError:error];
}

- (void)rewardedWillPresent:(BDMRewarded *)rewarded {
    id<GADMediationRewardedAdEventDelegate> strongDelegate = _delegate;
    [strongDelegate willPresentFullScreenView];
    [strongDelegate didStartVideo];
}

- (void)rewardedDidDismiss:(BDMRewarded *)rewarded {
    id<GADMediationRewardedAdEventDelegate> strongDelegate = _delegate;
    [strongDelegate willDismissFullScreenView];
    [strongDelegate didEndVideo];
    [strongDelegate didDismissFullScreenView];
}

- (void)rewardedFinishRewardAction:(BDMRewarded *)rewarded {
    id<GADMediationRewardedAdEventDelegate> strongDelegate = _delegate;
    GADAdReward *reward = [[GADAdReward alloc] initWithRewardType:@"" rewardAmount:NSDecimalNumber.zero];
    [strongDelegate didRewardUserWithReward:reward];
}

@end
