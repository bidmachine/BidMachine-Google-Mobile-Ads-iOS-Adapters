//
//  GADMBidMachineBannerAd.h
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BidMachine/BidMachine.h>
#import <GoogleMobileAds/GoogleMobileAds.h>


@interface GADMBidMachineBannerAd : NSObject

- (instancetype)initWithConnector:(id<GADMAdNetworkConnector>)connector adapter:(id<GADMAdNetworkAdapter>)adapter;
- (void)getBannerWithSize:(GADAdSize)adSize;

@end

