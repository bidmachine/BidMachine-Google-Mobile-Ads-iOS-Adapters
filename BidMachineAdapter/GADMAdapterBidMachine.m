//
//  GADMAdapterBidMachine.m
//  GADMAdapterBidMachine
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADMAdapterBidMachine.h"
#import <BidMachine/BidMachine.h>

@interface GADMAdapterBidMachine() {
    
__weak id<GADMAdNetworkConnector> _connector;
    
}

@end

@implementation GADMAdapterBidMachine

+ (NSString *)adapterVersion {
    return @"1.0.3.0";
}

- (void)getBannerWithSize:(GADAdSize)adSize {
    <#code#>
}

- (void)getInterstitial {
    <#code#>
}

- (instancetype)initWithGADMAdNetworkConnector:(id<GADMAdNetworkConnector>)connector {
    if (!connector) {
        return nil;
    }
    self = [super init];
    if (self) {
        _connector = connector;
    }
    return self;
}

+ (Class<GADAdNetworkExtras>)networkExtrasClass {
    <#code#>
}

- (void)presentInterstitialFromRootViewController:(UIViewController *)rootViewController {
    <#code#>
}

- (void)stopBeingDelegate {
    <#code#>
}

@end
