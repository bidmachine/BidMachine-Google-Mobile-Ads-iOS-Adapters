//
//  GADBidMachineNetworkExtras.h
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface GADBidMachineNetworkExtras : NSObject <GADAdNetworkExtras>

@property (nonatomic, strong) NSString *sellerId;
@property (nonatomic, assign) BOOL testMode;
@property (nonatomic, assign) BOOL loggingEnabled;
@property (nonatomic, assign) NSString *userId;
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) NSArray <NSString *> *blockedCategories;
@property (nonatomic, strong) NSArray <NSString *> *blockedAdvertisers;
@property (nonatomic, strong) NSArray <NSString *> *blockedApps;
@property (nonatomic, strong) CLLocation *deviceLocation;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSURL *storeURL;
@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, assign) BOOL paid;

@end
