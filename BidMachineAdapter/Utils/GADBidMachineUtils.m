//
//  GADBidMachineUtils.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADBidMachineUtils.h"
#import "GADMAdapterBidMachineConstants.h"
#import "GADBidMachineNetworkExtras.h"

@interface GADBidMachineUtils()

@property (nonatomic, copy) NSString *currentSellerId;

@end

@implementation GADBidMachineUtils

+ (instancetype)sharedUtils {
    static GADBidMachineUtils * _sharedUtils;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUtils = GADBidMachineUtils.new;
    });
    return _sharedUtils;
}

- (void)initializeBidMachineWith:(NSString *)serverParameter
                         request:(GADCustomEventRequest *)request
                      completion:(void(^)(NSError * __Nullable))completion {
    NSDictionary *requestInfo = [[GADBidMachineUtils sharedUtils] getRequestInfoFrom:serverParameter request:request];
    NSString *sellerID = transfromSellerID(requestInfo[kBidMachineSellerId]);
    if (sellerID &&
        ![self.currentSellerId isEqualToString:sellerID]) {
        self.currentSellerId = sellerID;
        BOOL testModeEnabled = [requestInfo[kBidMachineTestMode] boolValue];
        BOOL loggingEnabled = [requestInfo[kBidMachineLoggingEnabled] boolValue];
        BDMSdkConfiguration *config = [BDMSdkConfiguration new];
        [config setTestMode:testModeEnabled];
        [[BDMSdk sharedSdk] setEnableLogging:loggingEnabled];
        [[BDMSdk sharedSdk] startSessionWithSellerID:self.currentSellerId
                                       configuration:config
                                          completion:^{
                                              NSLog(@"BidMachine SDK was successfully initialized!");
                                              completion(nil);
                                          }];
    } else {
        NSString *description = @"BidMachine's initialization skipped. The sellerId is empty or has an incorrect type.";
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : description,
                                   NSLocalizedFailureReasonErrorKey : description};
        NSError *error = [NSError errorWithDomain:@"com.google.mediation.bidmachine" code:0 userInfo:userInfo];
        completion ? completion(error) : nil;
        NSLog(@"BidMachine's initialization skipped. The sellerId is empty or has an incorrect type.");
    }
}

- (NSDictionary *)requestInfoFrom:(NSString *)string
                             request:(GADCustomEventRequest *)request{
    NSMutableDictionary *requestInfo = [NSMutableDictionary new];
    if (request.additionalParameters) {
        [requestInfo addEntriesFromDictionary:request.additionalParameters];
    }
    [requestInfo addEntriesFromDictionary:[self requestInfoFrom:string]];
    if (request.userHasLocation) {
        requestInfo[kBidMachineLatitude] = @(request.userLatitude);
        requestInfo[kBidMachineLongitude] = @(request.userLongitude);
    }
    return requestInfo;
}

- (NSDictionary *)requestInfoFrom:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *requestInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    return requestInfo;
}

- (NSDictionary *)requestInfoFromConnector:(id<GADMAdNetworkConnector>)connector {
    NSMutableDictionary *requestInfo = [NSMutableDictionary new];
    NSString *parameters = [connector.credentials valueForKey:@"parameter"];
    if (connector.testMode) {
        requestInfo[kBidMachineTestMode] = @YES;
    }
    if (connector.childDirectedTreatment) {
        requestInfo[kBidMachineCoppa] = @YES;
    }
    if (connector.networkExtras) {
        NSDictionary *networkExtras = [self requestInfoFromNetworkExtras:connector.networkExtras];
        [requestInfo addEntriesFromDictionary:networkExtras];
    }
    if (connector.credentials && parameters) {
        NSDictionary *params = [self requestInfoFrom:parameters];
        [requestInfo addEntriesFromDictionary:params];
    }
    requestInfo[kBidMachineSellerId] = transfromSellerID(requestInfo[kBidMachineSellerId]);
    return requestInfo;
}

- (NSDictionary *)requestInfoFromNetworkExtras:(GADBidMachineNetworkExtras *)networkExtras {
    NSMutableDictionary *requestInfo = [NSMutableDictionary new];
    requestInfo[kBidMachineSellerId] = networkExtras.sellerId;
    requestInfo[kBidMachineTestMode] = @(networkExtras.testMode);
    requestInfo[kBidMachineLoggingEnabled] = @(networkExtras.loggingEnabled);
    requestInfo[kBidMachineSubjectToGDPR] = @(networkExtras.isUnderGDPR);
    requestInfo[kBidMachineHasConsent] = @(networkExtras.hasUserConsent);
    requestInfo[kBidMachineConsentString] = networkExtras.consentString;
    requestInfo[kBidMachineUserId] = networkExtras.userId;
    requestInfo[kBidMachineKeywords] = networkExtras.keywords;
    requestInfo[kBidMachineGender] = networkExtras.gender;
    requestInfo[kBidMachineYearOfBirth] = networkExtras.yearOfBirth;
    requestInfo[kBidMachineBlockedCategories] = [networkExtras.blockedCategories componentsJoinedByString:@","];
    requestInfo[kBidMachineBlockedAdvertisers] = [networkExtras.blockedAdvertisers componentsJoinedByString:@","];
    requestInfo[kBidMachineBlockedApps] = [networkExtras.blockedApps componentsJoinedByString:@","];
    requestInfo[kBidMachineCountry] = networkExtras.country;
    requestInfo[kBidMachineCity] = networkExtras.city;
    requestInfo[kBidMachineZip] = networkExtras.zip;
    requestInfo[kBidMachineStoreURL] = networkExtras.storeURL.absoluteString;
    requestInfo[kBidMachineStoreId] = networkExtras.storeId;
    requestInfo[kBidMachinePaid] = @(networkExtras.paid);
    requestInfo[kBidMachineLatitude] = @(networkExtras.userLatitude);
    requestInfo[kBidMachineLongitude] = @(networkExtras.userLongitude);
    if (networkExtras.coppa) {
        requestInfo[kBidMachineCoppa] = @YES;
    }
    requestInfo[kBidMachinePriceFloors] = networkExtras.priceFloors;
    return requestInfo;
}

- (BDMTargeting *)setupTargetingWithRequestInfo:(NSDictionary *)requestInfo andLocation:(CLLocation *)location {
    BDMTargeting * targeting = [BDMTargeting new];
    if (location) {
        [targeting setDeviceLocation:location];
    }
    if (requestInfo) {
        (!requestInfo[kBidMachineUserId]) ?: [targeting setUserId:(NSString *)requestInfo[kBidMachineUserId]];
        (!requestInfo[kBidMachineGender]) ?: [targeting setGender:userGenderSettingFromString(requestInfo[kBidMachineGender])];
        (!requestInfo[kBidMachineYearOfBirth]) ?: [targeting setYearOfBirth:requestInfo[kBidMachineYearOfBirth]];
        (!requestInfo[kBidMachineKeywords]) ?: [targeting setKeywords:requestInfo[kBidMachineKeywords]];
        (!requestInfo[kBidMachineBlockedCategories]) ?: [targeting setBlockedCategories:[requestInfo[kBidMachineBlockedCategories] componentsSeparatedByString:@","]];
        (!requestInfo[kBidMachineBlockedAdvertisers]) ?: [targeting setBlockedAdvertisers:[requestInfo[kBidMachineBlockedAdvertisers] componentsSeparatedByString:@","]];
        (!requestInfo[kBidMachineBlockedApps]) ?: [targeting setBlockedApps:[requestInfo[kBidMachineBlockedApps] componentsSeparatedByString:@","]];
        (!requestInfo[kBidMachineCountry]) ?: [targeting setCountry:requestInfo[kBidMachineCountry]];
        (!requestInfo[kBidMachineCity]) ?: [targeting setCity:requestInfo[kBidMachineCity]];
        (!requestInfo[kBidMachineZip]) ?: [targeting setZip:requestInfo[kBidMachineZip]];
        (!requestInfo[kBidMachineStoreURL]) ?: [targeting setStoreURL:[NSURL URLWithString:requestInfo[kBidMachineStoreURL]]];
        (!requestInfo[kBidMachineStoreId]) ?: [targeting setStoreId:requestInfo[kBidMachineStoreId]];
        (!requestInfo[kBidMachinePaid]) ?: [targeting setPaid:[requestInfo[kBidMachinePaid] boolValue]];
    }
    return targeting;
}

@end
