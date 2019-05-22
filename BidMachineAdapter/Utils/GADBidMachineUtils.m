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


GADVersionNumber GADVersionNumberFromBidMachineString(NSString *version) {
    GADVersionNumber gadVersion = {0};
    NSArray<NSString *> *components = [version componentsSeparatedByString:@"."];
    if (components.count == 3) {
        gadVersion.majorVersion = components[0].integerValue;
        gadVersion.minorVersion = components[1].integerValue;
        gadVersion.patchVersion = components[2].integerValue;
    }
    return gadVersion;
}


BDMBannerAdSize BDMBannerAdSizeFromGADAdSize(GADAdSize gadAdSize) {
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


BDMFullscreenAdType BDMFullscreenAdTypeFromString(NSString *string) {
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


BDMUserGender *BDMUserGenderFromString(NSString *gender) {
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


NSString *BidMachineSellerID(id sellerId) {
    NSString *stringSellerId;
    if ([sellerId isKindOfClass:NSString.class] && [sellerId integerValue]) {
        stringSellerId = sellerId;
    } else if ([sellerId isKindOfClass:NSNumber.class]) {
        stringSellerId = [sellerId stringValue];
    }
    return stringSellerId;
}


NSArray<BDMPriceFloor *> *BDMPriceFloors(NSArray *priceFloors) {
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


@interface GADBidMachineUtils ()

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

- (void)initializeBidMachineWithRequestInfo:(NSDictionary *)requestInfo
                                 completion:(void(^)(NSError *))completion {
    NSString *sellerID = BidMachineSellerID(requestInfo[kBidMachineSellerId]);
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
                                              completion ? completion(nil) : nil;
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
                          request:(GADCustomEventRequest *)request {
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
    
    requestInfo[kBidMachineSellerId] = BidMachineSellerID(requestInfo[kBidMachineSellerId]);
    return requestInfo;
}

- (NSDictionary *)requestInfoFromNetworkExtras:(GADBidMachineNetworkExtras *)networkExtras {
    NSMutableDictionary *requestInfo = [NSMutableDictionary new];
    requestInfo[kBidMachineSellerId]            = networkExtras.sellerId;
    requestInfo[kBidMachineTestMode]            = @(networkExtras.testMode);
    requestInfo[kBidMachineLoggingEnabled]      = @(networkExtras.loggingEnabled);
    requestInfo[kBidMachineSubjectToGDPR]       = @(networkExtras.isUnderGDPR);
    requestInfo[kBidMachineHasConsent]          = @(networkExtras.hasUserConsent);
    requestInfo[kBidMachineConsentString]       = networkExtras.consentString;
    requestInfo[kBidMachineUserId]              = networkExtras.userId;
    requestInfo[kBidMachineKeywords]            = networkExtras.keywords;
    requestInfo[kBidMachineGender]              = networkExtras.gender;
    requestInfo[kBidMachineYearOfBirth]         = networkExtras.yearOfBirth;
    requestInfo[kBidMachineBlockedCategories]   = [networkExtras.blockedCategories componentsJoinedByString:@","];
    requestInfo[kBidMachineBlockedAdvertisers]  = [networkExtras.blockedAdvertisers componentsJoinedByString:@","];
    requestInfo[kBidMachineBlockedApps]         = [networkExtras.blockedApps componentsJoinedByString:@","];
    requestInfo[kBidMachineCountry]             = networkExtras.country;
    requestInfo[kBidMachineCity]                = networkExtras.city;
    requestInfo[kBidMachineZip]                 = networkExtras.zip;
    requestInfo[kBidMachineStoreURL]            = networkExtras.storeURL.absoluteString;
    requestInfo[kBidMachineStoreId]             = networkExtras.storeId;
    requestInfo[kBidMachinePaid]                = @(networkExtras.paid);
    requestInfo[kBidMachineLatitude]            = @(networkExtras.userLatitude);
    requestInfo[kBidMachineLongitude]           = @(networkExtras.userLongitude);
    requestInfo[kBidMachinePriceFloors]         = networkExtras.priceFloors;
    
    if (networkExtras.coppa) {
        requestInfo[kBidMachineCoppa] = @YES;
    }
    
    return requestInfo;
}

- (BDMTargeting *)targetingWithRequestInfo:(NSDictionary *)requestInfo
                                  location:(CLLocation *)location {
    BDMTargeting * targeting = [BDMTargeting new];
    
    if (location) {
        [targeting setDeviceLocation:location];
    }
    
    if (requestInfo) {
        targeting.userId                = requestInfo[kBidMachineUserId] ?: targeting.userId;
        targeting.gender                = requestInfo[kBidMachineGender] ?: targeting.gender;
        targeting.yearOfBirth           = requestInfo[kBidMachineYearOfBirth] ?: targeting.yearOfBirth;
        targeting.keywords              = requestInfo[kBidMachineKeywords] ?: targeting.keywords;
        targeting.blockedCategories     = [requestInfo[kBidMachineBlockedCategories] componentsSeparatedByString:@","] ?: targeting.blockedCategories;
        targeting.blockedAdvertisers    = [requestInfo[kBidMachineBlockedAdvertisers] componentsSeparatedByString:@","] ?: targeting.blockedAdvertisers;
        targeting.blockedApps           = [requestInfo[kBidMachineBlockedApps] componentsSeparatedByString:@","] ?: targeting.blockedApps;
        targeting.country               = requestInfo[kBidMachineCountry] ?: targeting.country;
        targeting.city                  = requestInfo[kBidMachineCity] ?: targeting.city;
        targeting.zip                   = requestInfo[kBidMachineZip] ?: targeting.zip;
        targeting.storeURL              = requestInfo[kBidMachineStoreURL] ? [NSURL URLWithString:requestInfo[kBidMachineStoreURL]] : targeting.storeURL;
        targeting.storeId               = requestInfo[kBidMachineStoreId] ?: targeting.storeId;
        targeting.paid                  = requestInfo[kBidMachinePaid] ? [requestInfo[kBidMachinePaid] boolValue] : targeting.paid;
    }
    
    return targeting;
}

@end
