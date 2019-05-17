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

@implementation GADBidMachineUtils

+ (instancetype)sharedUtils {
    static GADBidMachineUtils * _sharedUtils;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUtils = GADBidMachineUtils.new;
    });
    return _sharedUtils;
}

- (void)initializeBidMachineWith:(nullable NSString *)serverParameter request:(nonnull GADCustomEventRequest *)request {
    NSDictionary *requestInfo = [[GADBidMachineUtils sharedUtils] getRequestInfoFrom:serverParameter request:request];
    NSString *sellerId = [requestInfo[kBidMachineSellerId] stringValue];
    BOOL testModeEnabled = [requestInfo[kBidMachineTestMode] boolValue];
    BOOL loggingEnabled = [requestInfo[kBidMachineLoggingEnabled] boolValue];
    if (sellerId) {
        BDMSdkConfiguration *config = [BDMSdkConfiguration new];
        [config setTestMode:testModeEnabled];
        [[BDMSdk sharedSdk] setEnableLogging:loggingEnabled];
        [[BDMSdk sharedSdk] startSessionWithSellerID:sellerId configuration:config completion:^{
            NSLog(@"BidMachine SDK was successfully initialized!");
        }];
    } else {
        NSLog(@"BidMachine's initialization skipped. The sellerId is empty or has an incorrect type.");
    }
}

- (NSDictionary *)getRequestInfoFrom:(NSString *)string
                             request:(GADCustomEventRequest *)request{
    NSMutableDictionary *requestInfo = [[self getRequestInfoFrom:string] mutableCopy];
    if (request.additionalParameters) {
        [requestInfo addEntriesFromDictionary:request.additionalParameters];
    }
    if (request.userHasLocation) {
        requestInfo[kBidMachineLatitude] = @(request.userLatitude);
        requestInfo[kBidMachineLongitude] = @(request.userLongitude);
    }
    return requestInfo;
}

- (NSDictionary *)getRequestInfoFrom:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *requestInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    return requestInfo;
}

- (GADVersionNumber)getSDKVersionFrom:(NSString *)version {
    GADVersionNumber gadVersion = {0};
    NSArray<NSString *> *components = [version componentsSeparatedByString:@"."];
    if (components.count == 3) {
        gadVersion.majorVersion = components[0].integerValue;
        gadVersion.minorVersion = components[1].integerValue;
        gadVersion.patchVersion = components[2].integerValue;
    }
    return gadVersion;
}

- (BDMBannerAdSize)getBannerAdSizeFrom:(GADAdSize)gadAdSize {
    BDMBannerAdSize adSize;
    CGSize transformedSize = CGSizeFromGADAdSize(gadAdSize);
    switch ((int)transformedSize.height) {
        case 50:  adSize = BDMBannerAdSize320x50;   break;
        case 90:  adSize = BDMBannerAdSize728x90;   break;
        case 250: adSize = BDMBannerAdSize300x250;  break;
        default:  adSize = BDMBannerAdSizeUnknown;  break;
    }
    return adSize;
}

- (NSDictionary *)getRequestInfoFromConnector:(id<GADMAdNetworkConnector>)connector {
    NSMutableDictionary *requestInfo = [NSMutableDictionary new];
    NSString *parameters = [connector.credentials valueForKey:@"parameter"];
    if (connector.testMode) {
        requestInfo[kBidMachineTestMode] = @YES;
    }
    if (connector.childDirectedTreatment) {
        requestInfo[kBidMachineCoppa] = @YES;
    }
    if (connector.networkExtras) {
        NSDictionary *networkExtras = [self getRequestInfoFromNetworkExtras:connector.networkExtras];
        [requestInfo addEntriesFromDictionary:networkExtras];
    }
    if (connector.credentials && parameters) {
        NSDictionary *params = [self getRequestInfoFrom:parameters];
        [requestInfo addEntriesFromDictionary:params];
    }
    return requestInfo;
}

- (NSDictionary *)getRequestInfoFromNetworkExtras:(GADBidMachineNetworkExtras *)networkExtras {
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
        (!requestInfo[kBidMachineGender]) ?: [targeting setGender:[self userGenderSetting:requestInfo[kBidMachineGender]]];
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

- (NSArray<BDMPriceFloor *> *)makePriceFloorsWithPriceFloors:(NSArray *)priceFloors {
    NSMutableArray<BDMPriceFloor *> *priceFloorsArr = [NSMutableArray new];
    [priceFloors enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSDictionary.class]) {
            BDMPriceFloor *priceFloor = [BDMPriceFloor new];
            NSDictionary *object = (NSDictionary *)obj;
            [priceFloor setID: object.allKeys[0]];
            [priceFloor setValue: object.allValues[0]];
            [priceFloorsArr addObject:priceFloor];
        } else if ([obj isKindOfClass:NSNumber.class]) {
            BDMPriceFloor *priceFloor = [BDMPriceFloor new];
            NSNumber *object = (NSNumber *)obj;
            [priceFloor setID:NSUUID.UUID.UUIDString.lowercaseString];
            [priceFloor setValue:[NSDecimalNumber decimalNumberWithDecimal:object.decimalValue]];
            [priceFloorsArr addObject:priceFloor];
        }
        if (idx == [priceFloors count] - 1) {
            *stop = YES;
        }
    }];
    return priceFloorsArr;
}

- (BDMUserGender *)userGenderSetting:(NSString *)gender {
    BDMUserGender *userGender;
    if ([gender isEqualToString:@"F"]) {
        userGender = kBDMUserGenderFemale;
    } else if ([gender isEqualToString:@"M"]) {
        userGender = kBDMUserGenderMale;
    } else if ([gender isEqualToString:@"O"]) {
        userGender = kBDMUserGenderUnknown;
    }
    return userGender;
}

@end
