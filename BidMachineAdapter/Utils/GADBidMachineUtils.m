//
//  GADBidMachineUtils.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADBidMachineUtils.h"
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
    NSString *sellerId = [requestInfo[@"seller_id"] stringValue];
    BOOL testModeEnabled = [requestInfo[@"test_mode"] boolValue];
    BOOL loggingEnabled = [requestInfo[@"logging_enabled"] boolValue];
    if (sellerId) {
        BDMSdkConfiguration *config = [BDMSdkConfiguration new];
        [config setTestMode:testModeEnabled];
        [[BDMSdk sharedSdk] setEnableLogging:loggingEnabled];
        [[BDMSdk sharedSdk] startSessionWithSellerID:sellerId configuration:config completion:^{
            NSLog(@"BidMachine SDK was successfully initialized!");
        }];
    }
}

- (NSDictionary *)getRequestInfoFrom:(NSString *)string
                             request:(GADCustomEventRequest *)request{
    NSMutableDictionary *requestInfo = [[self getRequestInfoFrom:string] mutableCopy];
    if (request.additionalParameters) {
        [requestInfo addEntriesFromDictionary:request.additionalParameters];
    }
    if (request.userHasLocation) {
        requestInfo[@"lat"] = @(request.userLatitude);
        requestInfo[@"lon"] = @(request.userLongitude);
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
        requestInfo[@"test_mode"] = @YES;
    }
    if (connector.childDirectedTreatment) {
        requestInfo[@"coppa"] = @YES;
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
    requestInfo[@"seller_id"] = networkExtras.sellerId;
    requestInfo[@"test_mode"] = @(networkExtras.testMode);
    requestInfo[@"logging_enabled"] = @(networkExtras.loggingEnabled);
    requestInfo[@"userId"] = networkExtras.userId;
    requestInfo[@"keywords"] = networkExtras.keywords;
    requestInfo[@"bcat"] = [networkExtras.blockedCategories componentsJoinedByString:@","];
    requestInfo[@"badv"] = [networkExtras.blockedAdvertisers componentsJoinedByString:@","];
    requestInfo[@"bapps"] = [networkExtras.blockedApps componentsJoinedByString:@","];
    requestInfo[@"country"] = networkExtras.country;
    requestInfo[@"city"] = networkExtras.city;
    requestInfo[@"zip"] = networkExtras.zip;
    requestInfo[@"sturl"] = networkExtras.storeURL.absoluteString;
    requestInfo[@"stid"] = networkExtras.storeId;
    requestInfo[@"paid"] = @(networkExtras.paid);
    requestInfo[@"gdpr"] = @(networkExtras.isUnderGDPR);
    requestInfo[@"consent"] = @(networkExtras.hasUserConsent);
    if (networkExtras.coppa) {
        requestInfo[@"coppa"] = @YES;
    }
    requestInfo[@"priceFloors"] = networkExtras.priceFloors;
    return requestInfo;
}

- (BDMTargeting *)setupTargetingWithRequestInfo:(NSDictionary *)requestInfo andLocation:(CLLocation *)location {
    BDMTargeting * targeting = [BDMTargeting new];
    if (location) {
        [targeting setDeviceLocation:location];
    }
    if (requestInfo) {
        (!requestInfo[@"userId"]) ?: [targeting setUserId:(NSString *)requestInfo[@"userId"]];
        (!requestInfo[@"keywords"]) ?: [targeting setKeywords:requestInfo[@"keywords"]];
        (!requestInfo[@"bcat"]) ?: [targeting setBlockedCategories:[requestInfo[@"bcat"] componentsSeparatedByString:@","]];
        (!requestInfo[@"badv"]) ?: [targeting setBlockedAdvertisers:[requestInfo[@"badv"] componentsSeparatedByString:@","]];
        (!requestInfo[@"bapps"]) ?: [targeting setBlockedApps:[requestInfo[@"bapps"] componentsSeparatedByString:@","]];
        (!requestInfo[@"country"]) ?: [targeting setCountry:requestInfo[@"country"]];
        (!requestInfo[@"city"]) ?: [targeting setCity:requestInfo[@"city"]];
        (!requestInfo[@"zip"]) ?: [targeting setZip:requestInfo[@"zip"]];
        (!requestInfo[@"sturl"]) ?: [targeting setStoreURL:[NSURL URLWithString:requestInfo[@"sturl"]]];
        (!requestInfo[@"stid"]) ?: [targeting setStoreId:requestInfo[@"stid"]];
        (!requestInfo[@"paid"]) ?: [targeting setPaid:[requestInfo[@"paid"] boolValue]];
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

@end
