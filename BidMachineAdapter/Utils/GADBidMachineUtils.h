//
//  GADBidMachineUtils.h
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BidMachine/BidMachine.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface GADBidMachineUtils : NSObject

+ (instancetype)sharedUtils;
- (void)initializeBidMachineWith:(nullable NSString *)serverParameter request:(nonnull GADCustomEventRequest *)request;
- (NSDictionary *)getRequestInfoFrom:(NSString *)string request:(GADCustomEventRequest *)request;
- (GADVersionNumber)getSDKVersionFrom:(NSString *)version;
- (BDMBannerAdSize)getBannerAdSizeFrom:(GADAdSize)size;
- (NSDictionary *)getRequestInfoFromConnector:(id<GADMRewardBasedVideoAdNetworkConnector>)connector;
- (BDMTargeting *)setupTargetingWithRequestInfo:(NSDictionary *)requestInfo andLocation:(CLLocation *)location;
- (NSArray<BDMPriceFloor *> *)makePriceFloorsWithPriceFloors:(NSArray *)priceFloors;

@end
