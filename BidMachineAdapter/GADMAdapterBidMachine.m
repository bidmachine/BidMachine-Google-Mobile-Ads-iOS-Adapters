//
//  GADMAdapterBidMachine.m
//  GADMAdapterBidMachine
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADMAdapterBidMachine.h"
#import "GADMBidMachineBannerAd.h"
#import "GADBidMachineNetworkExtras.h"
#import <BidMachine/BidMachine.h>

@interface GADMAdapterBidMachine()
    
@property (nonatomic, weak) id<GADMAdNetworkConnector> connector;
@property (nonatomic, strong) GADMBidMachineBannerAd *banner;

@end

@implementation GADMAdapterBidMachine

+ (NSString *)adapterVersion {
    return @"1.0.3.0";
}

+ (Class<GADAdNetworkExtras>)networkExtrasClass {
    return GADBidMachineNetworkExtras.class;
}

- (instancetype)initWithGADMAdNetworkConnector:(id<GADMAdNetworkConnector>)connector {
    if (!connector) {
        return nil;
    }
    self = [super init];
    if (self) {
        _connector = connector;
        _banner = [[GADMBidMachineBannerAd alloc] initWithConnector:connector adapter:self];
    }
    return self;
}

- (void)getBannerWithSize:(GADAdSize)adSize {
    [self.banner getBannerWithSize:adSize];
}

- (void)getInterstitial {
    
}

- (void)presentInterstitialFromRootViewController:(UIViewController *)rootViewController {
    
}

- (void)stopBeingDelegate {
    
}

@end
