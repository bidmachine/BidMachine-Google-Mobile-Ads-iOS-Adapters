//
//  GADBidMachineNetworkExtras.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADBidMachineNetworkExtras.h"
#import "GADMAdapterBidMachineConstants.h"

@implementation GADBidMachineNetworkExtras

- (NSDictionary *)extras {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    if (self) {
        dict[kBidMachineSellerId] = self.sellerId;
        dict[kBidMachineTestMode] = @(self.testMode);
        dict[kBidMachineLoggingEnabled] = @(self.loggingEnabled);
        dict[kBidMachineSubjectToGDPR] = @(self.isUnderGDPR);
        dict[kBidMachineHasConsent] = @(self.hasUserConsent);
        dict[kBidMachineConsentString] = self.consentString;
        dict[kBidMachineUserId] = self.userId;
        dict[kBidMachineKeywords] = self.keywords;
        dict[kBidMachineGender] = self.gender;
        dict[kBidMachineYearOfBirth] = self.yearOfBirth;
        dict[kBidMachineBlockedCategories] = [self.blockedCategories componentsJoinedByString:@","];
        dict[kBidMachineBlockedAdvertisers] = [self.blockedAdvertisers componentsJoinedByString:@","];
        dict[kBidMachineBlockedApps] = [self.blockedApps componentsJoinedByString:@","];
        dict[kBidMachineCountry] = self.country;
        dict[kBidMachineCity] = self.city;
        dict[kBidMachineZip] = self.zip;
        dict[kBidMachineStoreURL] = self.storeURL.absoluteString;
        dict[kBidMachineStoreId] = self.storeId;
        dict[kBidMachinePaid] = @(self.paid);
        dict[kBidMachineLatitude] = @(self.userLatitude);
        dict[kBidMachineLongitude] = @(self.userLongitude);
        if (self.coppa) {
            dict[kBidMachineCoppa] = @YES;
        }
        dict[kBidMachinePriceFloors] = self.priceFloors;
    }
    return dict;
}

@end
