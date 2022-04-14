//
//  BidMachineMediationAdapter.m
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 13.04.2022.
//  Copyright © 2022 Ilia Lozhkin. All rights reserved.
//

#import "BidMachineMediationAdapter.h"
#include <stdatomic.h>

@import BidMachine;
@import StackFoundation;
@import BidMachine.ExternalAdapterUtils;

@interface BidMachineMediationAdapter ()

@property(nonatomic, strong, readonly) BDMExternalAdapterConfiguration *configuration;
@property(nonatomic, strong, readonly) BDMExternalAdapterRequestController *requestController;

@end

@implementation BidMachineMediationAdapter

- (instancetype)initBannerWithConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration
                          completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler {
    NSDictionary *extraInfo = [self extraInfoFromConfiguration:adConfiguration];
    if (self = [super init]) {
        _configuration = [BDMExternalAdapterConfiguration configurationWithBuilder:^(id<BDMExternalAdapterConfigurationBuilderProtocol> builder) {
            builder.appendJsonConfiguration(extraInfo);
            builder.appendAdSize(CGSizeFromGADAdSize(adConfiguration.adSize));
        }];
        
        _requestController = [[BDMExternalAdapterRequestController alloc] initWithType:BDMInternalPlacementTypeBanner
                                                                              delegate:self];
    }
    return self;
}

- (instancetype)initInterstitialWithConfiguration:(GADMediationInterstitialAdConfiguration *)adConfiguration
                                completionHandler:(GADMediationInterstitialLoadCompletionHandler)completionHandler {
    NSDictionary *extraInfo = [self extraInfoFromConfiguration:adConfiguration];
    if (self = [super init]) {
        _configuration = [BDMExternalAdapterConfiguration configurationWithBuilder:^(id<BDMExternalAdapterConfigurationBuilderProtocol> builder) {
            builder.appendJsonConfiguration(extraInfo);
        }];
        
        _requestController = [[BDMExternalAdapterRequestController alloc] initWithType:BDMInternalPlacementTypeInterstitial
                                                                              delegate:self];
    }
    return self;
}

- (instancetype)initRewardedWithConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                            completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {
    NSDictionary *extraInfo = [self extraInfoFromConfiguration:adConfiguration];
    if (self = [super init]) {
        _configuration = [BDMExternalAdapterConfiguration configurationWithBuilder:^(id<BDMExternalAdapterConfigurationBuilderProtocol> builder) {
            builder.appendJsonConfiguration(extraInfo);
        }];
        
        _requestController = [[BDMExternalAdapterRequestController alloc] initWithType:BDMInternalPlacementTypeRewardedVideo
                                                                              delegate:self];
    }
    return self;
}

- (instancetype)initNativeWithConfiguration:(GADMediationNativeAdConfiguration *)adConfiguration
                          completionHandler:(GADMediationNativeLoadCompletionHandler)completionHandler {
    NSDictionary *extraInfo = [self extraInfoFromConfiguration:adConfiguration];
    if (self = [super init]) {
        _configuration = [BDMExternalAdapterConfiguration configurationWithBuilder:^(id<BDMExternalAdapterConfigurationBuilderProtocol> builder) {
            builder.appendJsonConfiguration(extraInfo);
        }];
        
        _requestController = [[BDMExternalAdapterRequestController alloc] initWithType:BDMInternalPlacementTypeNative
                                                                              delegate:self];
    }
    return self;
}

- (void)loadAd {
    [self.requestController prepareRequestWithConfiguration:self.configuration];
}

#pragma mark - Private

- (NSDictionary *)extraInfoFromConfiguration:(GADMediationAdConfiguration *)configuration {
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

- (void)controller:(nonnull BDMExternalAdapterRequestController *)controller didFailPrepareRequest:(nonnull NSError *)error {
    // no-op should be overide in child class
}

- (void)controller:(nonnull BDMExternalAdapterRequestController *)controller didPrepareRequest:(nonnull BDMRequest *)request {
    // no-op should be overide in child class
}

@end
