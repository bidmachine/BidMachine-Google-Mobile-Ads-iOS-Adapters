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
                                     requestInfo:(NSDictionary *)requestInfo {
    BDMBannerRequest *bannerRequest = [BDMBannerRequest new];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[requestInfo[kBidMachineLatitude] doubleValue] longitude:[requestInfo[kBidMachineLongitude] doubleValue]];
    [bannerRequest setAdSize:size];
    [[BDMSdk sharedSdk] setRestrictions:[self setupUserRestrictionsWithRequestInfo:requestInfo]];
    [bannerRequest setTargeting:[[GADBidMachineUtils sharedUtils] setupTargetingWithRequestInfo:requestInfo andLocation:location]];
    [bannerRequest setPriceFloors:makePriceFloorsWithPriceFloors(requestInfo[kBidMachinePriceFloors])];
    return bannerRequest;
}

- (BDMInterstitialRequest *)interstitialRequestWithRequestInfo:(NSDictionary *)requestInfo {
    BDMInterstitialRequest *interstitialRequest = [BDMInterstitialRequest new];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[requestInfo[kBidMachineLatitude] doubleValue] longitude:[requestInfo[kBidMachineLongitude] doubleValue]];
    [interstitialRequest setType:setupInterstitialAdType(requestInfo[kBidMachineAdContentType])];
    [[BDMSdk sharedSdk] setRestrictions:[self setupUserRestrictionsWithRequestInfo:requestInfo]];
    [interstitialRequest setTargeting:[[GADBidMachineUtils sharedUtils] setupTargetingWithRequestInfo:requestInfo andLocation:location]];
    [interstitialRequest setPriceFloors:makePriceFloorsWithPriceFloors(requestInfo[kBidMachinePriceFloors])];
    return interstitialRequest;
}

- (BDMRewardedRequest *)rewardedRequestWithRequestInfo:(NSDictionary *)requestInfo {
    BDMRewardedRequest *rewardedRequest = [BDMRewardedRequest new];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[requestInfo[kBidMachineLatitude] doubleValue] longitude:[requestInfo[kBidMachineLongitude] doubleValue]];
    [[BDMSdk sharedSdk] setRestrictions:[self setupUserRestrictionsWithRequestInfo:requestInfo]];
    [rewardedRequest setTargeting:[[GADBidMachineUtils sharedUtils] setupTargetingWithRequestInfo:requestInfo andLocation:location]];
    [rewardedRequest setPriceFloors:makePriceFloorsWithPriceFloors(requestInfo[kBidMachinePriceFloors])];
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

@end
