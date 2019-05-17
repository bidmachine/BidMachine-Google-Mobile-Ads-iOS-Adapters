//
//  GADBidMachineUtils+Request.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADBidMachineUtils+Request.h"
#import "GADMAdapterBidMachineConstants.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <BidMachine/BidMachine.h>

@implementation GADBidMachineUtils (Request)

- (BDMBannerRequest *)setupBannerRequestWithSize:(BDMBannerAdSize)size
                                 serverParameter:(NSString *)serverParameter
                                         request:(GADCustomEventRequest *)request{
    BDMBannerRequest *bannerRequest = [BDMBannerRequest new];
    NSDictionary *requestInfo = [[GADBidMachineUtils sharedUtils] getRequestInfoFrom:serverParameter request:request];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[requestInfo[kBidMachineLatitude] doubleValue] longitude:[requestInfo[kBidMachineLongitude] doubleValue]];
    [bannerRequest setAdSize:size];
    [[BDMSdk sharedSdk] setRestrictions:[self setupUserRestrictionsWithRequestInfo:requestInfo]];
    [bannerRequest setTargeting:[[GADBidMachineUtils sharedUtils] setupTargetingWithRequestInfo:requestInfo andLocation:location]];
    [bannerRequest setPriceFloors:[self makePriceFloorsWithPriceFloors:requestInfo[kBidMachinePriceFloors]]];
    return bannerRequest;
}

- (BDMInterstitialRequest *)interstitialRequestWithServerParameter:(NSString *)serverParameter
                                                           request:(GADCustomEventRequest *)request {
    BDMInterstitialRequest *interstitialRequest = [BDMInterstitialRequest new];
    NSDictionary *requestInfo = [[GADBidMachineUtils sharedUtils] getRequestInfoFrom:serverParameter request:request];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[requestInfo[kBidMachineLatitude] doubleValue] longitude:[requestInfo[kBidMachineLongitude] doubleValue]];
    [interstitialRequest setType:[self setupInterstitialAdType:requestInfo[kBidMachineAdContentType]]];
    [[BDMSdk sharedSdk] setRestrictions:[self setupUserRestrictionsWithRequestInfo:requestInfo]];
    [interstitialRequest setTargeting:[[GADBidMachineUtils sharedUtils] setupTargetingWithRequestInfo:requestInfo andLocation:location]];
    [interstitialRequest setPriceFloors:[self makePriceFloorsWithPriceFloors:requestInfo[kBidMachinePriceFloors]]];
    return interstitialRequest;
}

- (BDMRewardedRequest *)rewardedRequestWithConnector:(id<GADMRewardBasedVideoAdNetworkConnector>)rewardedAdConnector {
    BDMRewardedRequest *rewardedRequest = [BDMRewardedRequest new];
    NSDictionary *requestInfo = [[GADBidMachineUtils sharedUtils] getRequestInfoFromConnector:rewardedAdConnector];
    CLLocation *location;
    if (rewardedAdConnector.userHasLocation) {
        location = [[CLLocation alloc] initWithLatitude:rewardedAdConnector.userLatitude longitude:rewardedAdConnector.userLongitude];
    } else {
        location = [[CLLocation alloc] initWithLatitude:[requestInfo[kBidMachineLatitude] doubleValue] longitude:[requestInfo[kBidMachineLongitude] doubleValue]];
    }
    [[BDMSdk sharedSdk] setRestrictions:[self setupUserRestrictionsWithRequestInfo:requestInfo]];
    [rewardedRequest setTargeting:[[GADBidMachineUtils sharedUtils] setupTargetingWithRequestInfo:requestInfo andLocation:location]];
    [rewardedRequest setPriceFloors:[self makePriceFloorsWithPriceFloors:requestInfo[kBidMachinePriceFloors]]];
    return rewardedRequest;
}

- (BDMUserRestrictions *)setupUserRestrictionsWithRequestInfo:(NSDictionary *)requestInfo {
    BDMUserRestrictions *restrictions = [BDMUserRestrictions new];
    [restrictions setHasConsent:[requestInfo[kBidMachineHasConsent] boolValue]];
    [restrictions setSubjectToGDPR:[requestInfo[kBidMachineSubjectToGDPR] boolValue]];
    [restrictions setCoppa:[requestInfo[kBidMachineCoppa] boolValue]];
    [restrictions setConsentString:requestInfo[kBidMachineConsentString]];
    [[BDMSdk sharedSdk] setEnableLogging:[requestInfo[kBidMachineLoggingEnabled] boolValue]];
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
