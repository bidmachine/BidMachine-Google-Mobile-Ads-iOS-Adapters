//
//  GADMBidMachineRewardedAd.h
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/15/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import <GoogleMobileAds/GoogleMobileAds.h>

@interface GADMBidMachineRewardedAd : NSObject

- (instancetype)initWithConnector:(id<GADMAdNetworkConnector>)connector adapter:(id<GADMAdNetworkAdapter>)adapter;
- (void)getInterstitial;

@end

