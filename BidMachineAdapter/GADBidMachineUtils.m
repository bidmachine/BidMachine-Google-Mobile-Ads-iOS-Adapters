//
//  GADBidMachineUtils.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADBidMachineUtils.h"

@implementation GADBidMachineUtils

+ (BDMBannerAdSize)getBannerAdSizeFrom:(GADAdSize)gadAdSize {
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

+ (BDMTargeting *)setupTargetingWithExtraInfo:(NSDictionary *)extraInfo andLocation:(CLLocation *)location {
    BDMTargeting * targeting = [BDMTargeting new];
    if (location) {
        [targeting setDeviceLocation:location];
    }
    if (extraInfo) {
        (!extraInfo[@"userId"]) ?: [targeting setUserId:(NSString *)extraInfo[@"userId"]];
        (!extraInfo[@"yob"]) ?: [targeting setYearOfBirth:extraInfo[@"yob"]];
        (!extraInfo[@"keywords"]) ?: [targeting setKeywords:extraInfo[@"keywords"]];
        (!extraInfo[@"bcat"]) ?: [targeting setBlockedCategories:[extraInfo[@"bcat"] componentsSeparatedByString:@","]];
        (!extraInfo[@"badv"]) ?: [targeting setBlockedAdvertisers:[extraInfo[@"badv"] componentsSeparatedByString:@","]];
        (!extraInfo[@"bapps"]) ?: [targeting setBlockedApps:[extraInfo[@"bapps"] componentsSeparatedByString:@","]];
        (!extraInfo[@"country"]) ?: [targeting setCountry:extraInfo[@"country"]];
        (!extraInfo[@"city"]) ?: [targeting setCity:extraInfo[@"city"]];
        (!extraInfo[@"zip"]) ?: [targeting setZip:extraInfo[@"zip"]];
        (!extraInfo[@"sturl"]) ?: [targeting setStoreURL:[NSURL URLWithString:extraInfo[@"sturl"]]];
        (!extraInfo[@"stid"]) ?: [targeting setStoreId:extraInfo[@"stid"]];
        (!extraInfo[@"paid"]) ?: [targeting setPaid:[extraInfo[@"paid"] boolValue]];
    }
    return targeting;
}

+ (NSArray<BDMPriceFloor *> *)makePriceFloorsWithPriceFloors:(NSArray *)priceFloors {
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
