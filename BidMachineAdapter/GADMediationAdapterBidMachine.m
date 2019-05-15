//
//  GADMediationAdapterBidMachine.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADMediationAdapterBidMachine.h"
#import "GADBidMachineUtils.h"
#import "GADBidMachineNetworkExtras.h"
#import <BidMachine/BidMachine.h>

@implementation GADMediationAdapterBidMachine

+ (GADVersionNumber)adSDKVersion { 
    return [[GADBidMachineUtils sharedUtils] getSDKVersionFrom:kBDMVersion];
}

+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass { 
    return GADBidMachineNetworkExtras.class;
}

+ (GADVersionNumber)version { 
    return [[GADBidMachineUtils sharedUtils] getSDKVersionFrom:kBDMVersion];
}

+ (void)setUpWithConfiguration:(GADMediationServerConfiguration *)configuration
             completionHandler:(GADMediationAdapterSetUpCompletionBlock)completionHandler {
//    NSString *sellerId = configuration.credentials. [@"seller_id"];
    
}

- (void)loadBannerForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler {
    
}

- (void)loadInterstitialForAdConfiguration:(GADMediationInterstitialAdConfiguration *)adConfiguration completionHandler:(GADMediationInterstitialLoadCompletionHandler)completionHandler {
    
}

- (void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration completionHandler:(GADMediationRewardedLoadCompletionHandler)completionHandler {
    
}

@end
