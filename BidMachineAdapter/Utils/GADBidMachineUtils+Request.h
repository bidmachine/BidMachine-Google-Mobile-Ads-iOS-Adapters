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
                                 serverParameter:(NSString *)serverParameter
                                         request:(GADCustomEventRequest *)request;
- (BDMInterstitialRequest *)interstitialRequestWithServerParameter:(NSString *)serverParameter
                                                           request:(GADCustomEventRequest *)request;
- (BDMRewardedRequest *)rewardedRequestWithConnector:(id<GADMRewardBasedVideoAdNetworkConnector>)rewardedAdConnector;
@end
