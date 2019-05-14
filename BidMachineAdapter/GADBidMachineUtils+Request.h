//
//  GADBidMachineUtils+Request.h
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADBidMachineUtils.h"

@interface GADBidMachineUtils (Request)
- (BDMBannerRequest *)setupBannerRequestWithSize:(BDMBannerAdSize)size
                                       connector:(id<GADMAdNetworkConnector>)connector;
- (BDMInterstitialRequest *)interstitialRequestWithConnector:(id<GADMAdNetworkConnector>)connector;
- (BDMRewardedRequest *)rewardedRequestWithConnector:(id<GADMAdNetworkConnector>)connector;
@end
