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
                                       connector:(id<GADMAdNetworkConnector>)connector{
    BDMBannerRequest *request = [BDMBannerRequest new];
    NSDictionary *requestInfo = [[GADBidMachineUtils sharedUtils] getRequestInfoFromConnector:connector];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:connector.userLatitude longitude:connector.userLongitude];
    [request setAdSize:size];
    [[BDMSdk sharedSdk] setRestrictions:[self setupUserRestrictionsWithRequestInfo:requestInfo]];
    [request setTargeting:[[GADBidMachineUtils sharedUtils] setupTargetingWithRequestInfo:requestInfo andLocation:location]];
    [request setPriceFloors:[self makePriceFloorsWithPriceFloors:priceFloors]];
    return request;
}

- (BDMInterstitialRequest *)interstitialRequestWithConnector:(id<GADMAdNetworkConnector>)connector {
    BDMInterstitialRequest *request = [BDMInterstitialRequest new];
    NSDictionary *requestInfo = [[GADBidMachineUtils sharedUtils] getRequestInfoFromConnector:connector];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:connector.userLatitude longitude:connector.userLongitude];
    [request setType:[self setupInterstitialAdType:requestInfo[@"ad_content_type"]]];
    [[BDMSdk sharedSdk] setRestrictions:[self setupUserRestrictionsWithRequestInfo:requestInfo]];
    [request setTargeting:[[GADBidMachineUtils sharedUtils] setupTargetingWithExtraInfo:extraInfo andLocation:location]];
    [request setPriceFloors:[self makePriceFloorsWithPriceFloors:priceFloors]];
    return request;
}

- (BDMRewardedRequest *)rewardedRequestWithConnector:(id<GADMAdNetworkConnector>)connector {
    BDMRewardedRequest *request = [BDMRewardedRequest new];
    NSDictionary *requestInfo = [[GADBidMachineUtils sharedUtils] getRequestInfoFromConnector:connector];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:connector.userLatitude longitude:connector.userLongitude];
    [[BDMSdk sharedSdk] setRestrictions:[self setupUserRestrictionsWithRequestInfo:requestInfo]];
    [request setTargeting:[[GADBidMachineUtils sharedUtils] setupTargetingWithExtraInfo:extraInfo andLocation:location]];
    [request setPriceFloors:[self makePriceFloorsWithPriceFloors:priceFloors]];
    return request;
}

- (BDMUserRestrictions *)setupUserRestrictionsWithRequestInfo:(NSDictionary *)requestInfo {
    BDMUserRestrictions *restrictions = [BDMUserRestrictions new];
    [restrictions setHasConsent:[[MoPub sharedInstance] canCollectPersonalInfo]];
    [restrictions setSubjectToGDPR:[[MoPub sharedInstance] isGDPRApplicable]];
    [restrictions setCoppa:[extras[@"coppa"] boolValue]];
    [[BDMSdk sharedSdk] setEnableLogging:[extras[@"logging_enabled"] boolValue]];
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
