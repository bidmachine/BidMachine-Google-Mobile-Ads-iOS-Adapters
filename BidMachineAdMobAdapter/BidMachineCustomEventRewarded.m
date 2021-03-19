//
//  GADMBidMachineRewardedAd.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/15/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "BidMachineCustomEventRewarded.h"
#import "BidMachineCustomEventRewardedAd.h"

#import <BidMachine/BidMachine.h>


@interface BidMachineCustomEventRewarded () {
  BidMachineCustomEventRewardedAd *_rewardedAd;
}

@end


@implementation BidMachineCustomEventRewarded

+ (GADVersionNumber)adSDKVersion {
    return [self versionFromBidMachineString:kBDMVersion];
}

+ (GADVersionNumber)adapterVersion {
    return [self versionFromBidMachineString:@"1.6.5.0"];
}

+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass {
    return nil;
}

+ (void)setUpWithConfiguration:(nonnull GADMediationServerConfiguration *)configuration
             completionHandler:(nonnull GADMediationAdapterSetUpCompletionBlock)completionHandler {
    completionHandler(nil);
}

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {
    _rewardedAd = [[BidMachineCustomEventRewardedAd alloc] initWithConfiguration:adConfiguration completionHandler:completionHandler];
    [_rewardedAd loadRewardedVideo];
}

+ (GADVersionNumber)versionFromBidMachineString:(NSString *)version {
    GADVersionNumber gadVersion = {0};
    NSArray<NSString *> *components = [version componentsSeparatedByString:@"."];
    if (components.count == 3) {
        gadVersion.majorVersion = components[0].integerValue;
        gadVersion.minorVersion = components[1].integerValue;
        gadVersion.patchVersion = components[2].integerValue;
    }
    return gadVersion;
}

@end
