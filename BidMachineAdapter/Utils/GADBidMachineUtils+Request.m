//
//  GADBidMachineUtils+Request.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADBidMachineUtils+Request.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <BidMachine/BidMachine.h>

@implementation GADBidMachineUtils (Request)

- (BDMBannerRequest *)setupBannerRequestWithSize:(BDMBannerAdSize)size
                                 serverParameter:(NSString *)serverParameter
                                         request:(GADCustomEventRequest *)request{
    BDMBannerRequest *bannerRequest = [BDMBannerRequest new];
    NSDictionary *requestInfo = [[GADBidMachineUtils sharedUtils] getRequestInfoFrom:serverParameter request:request];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[requestInfo[@"lat"] doubleValue] longitude:[requestInfo[@"lon"] doubleValue]];
    [bannerRequest setAdSize:size];
    [[BDMSdk sharedSdk] setRestrictions:[self setupUserRestrictionsWithRequestInfo:requestInfo]];
    [bannerRequest setTargeting:[[GADBidMachineUtils sharedUtils] setupTargetingWithRequestInfo:requestInfo andLocation:location]];
    [bannerRequest setPriceFloors:[self makePriceFloorsWithPriceFloors:requestInfo[@"priceFloors"]]];
    return bannerRequest;
}

- (BDMInterstitialRequest *)interstitialRequestWithServerParameter:(NSString *)serverParameter
                                                           request:(GADCustomEventRequest *)request {
    BDMInterstitialRequest *interstitialRequest = [BDMInterstitialRequest new];
    NSDictionary *requestInfo = [[GADBidMachineUtils sharedUtils] getRequestInfoFrom:serverParameter request:request];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[requestInfo[@"lat"] doubleValue] longitude:[requestInfo[@"lon"] doubleValue]];
    [interstitialRequest setType:[self setupInterstitialAdType:requestInfo[@"ad_content_type"]]];
    [[BDMSdk sharedSdk] setRestrictions:[self setupUserRestrictionsWithRequestInfo:requestInfo]];
    [interstitialRequest setTargeting:[[GADBidMachineUtils sharedUtils] setupTargetingWithRequestInfo:requestInfo andLocation:location]];
    [interstitialRequest setPriceFloors:[self makePriceFloorsWithPriceFloors:requestInfo[@"priceFloors"]]];
    return interstitialRequest;
}

- (BDMRewardedRequest *)rewardedRequestWithConnector:(id<GADMRewardBasedVideoAdNetworkConnector>)rewardedAdConnector {
    BDMRewardedRequest *rewardedRequest = [BDMRewardedRequest new];
    NSDictionary *requestInfo = [[GADBidMachineUtils sharedUtils] getRequestInfoFromConnector:rewardedAdConnector];
    CLLocation *location;
    if (rewardedAdConnector.userHasLocation) {
        location = [[CLLocation alloc] initWithLatitude:rewardedAdConnector.userLatitude longitude:rewardedAdConnector.userLongitude];
    } else {
        location = [[CLLocation alloc] initWithLatitude:[requestInfo[@"lat"] doubleValue] longitude:[requestInfo[@"lon"] doubleValue]];
    }
    [[BDMSdk sharedSdk] setRestrictions:[self setupUserRestrictionsWithRequestInfo:requestInfo]];
    [rewardedRequest setTargeting:[[GADBidMachineUtils sharedUtils] setupTargetingWithRequestInfo:requestInfo andLocation:location]];
    [rewardedRequest setPriceFloors:[self makePriceFloorsWithPriceFloors:requestInfo[@"priceFloors"]]];
    return rewardedRequest;
}

- (BDMUserRestrictions *)setupUserRestrictionsWithRequestInfo:(NSDictionary *)requestInfo {
    BDMUserRestrictions *restrictions = [BDMUserRestrictions new];
    [restrictions setHasConsent:[requestInfo[@"consent"] boolValue]];
    [restrictions setSubjectToGDPR:[requestInfo[@"gdpr"] boolValue]];
    [restrictions setCoppa:[requestInfo[@"coppa"] boolValue]];
    [[BDMSdk sharedSdk] setEnableLogging:[requestInfo[@"logging_enabled"] boolValue]];
    return restrictions;
}

- (BDMFullscreenAdType)setupInterstitialAdType:(NSString *)string {
    BDMFullscreenAdType type;
    NSString *lowercasedString = [string lowercaseString];
    if ([lowercasedString isEqualToString:@"all"]) {
        type = BDMFullscreenAdTypeAll;
    } else if ([lowercasedString isEqualToString:@"video"]) {
        type = BDMFullscreenAdTypeVideo;
    } else if ([lowercasedString isEqualToString:@"static"]) {
        type = BDMFullsreenAdTypeBanner;
    } else {
        type = BDMFullscreenAdTypeAll;
    }
    return type;
}

@end
