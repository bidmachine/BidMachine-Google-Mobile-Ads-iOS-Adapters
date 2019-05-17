//
//  GADBidMachineNetworkExtras.h
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface GADBidMachineNetworkExtras : NSObject <GADAdNetworkExtras>
/**
 Your publisher id registered in exchange dashboard
 */
@property (nonatomic, strong) NSString *sellerId;
/**
 Enable/disable test mode
 */
@property (nonatomic, assign) BOOL testMode;
/**
 Enable logging. By default logging disabled.
 */
@property (nonatomic, assign) BOOL loggingEnabled;
/**
 Setup that user is under GDPR.
 */
@property (nonatomic, assign) BOOL isUnderGDPR;
/**
 Setup that user give consent
 */
@property (nonatomic, assign) BOOL hasUserConsent;
/**
 Setup that user is under COPPA.
 */
@property (nonatomic, assign) BOOL coppa;
/**
 * The consent string for sending the GDPR consent.
 */
@property (nonatomic, strong) NSString *consentString;
/**
 Vendor-specific ID for the user
 */
@property (nonatomic, assign) NSString *userId;
/**
 Comma separated list of keywords about the app
 */
@property (nonatomic, strong) NSString *keywords;
/**
 Blocked advertiser categories using the IAB content categories. Refer to List 5.1
 */
@property (nonatomic, strong) NSArray <NSString *> *blockedCategories;
/**
 Block list of advertisers by their domains (e.g., “ford.com”).
 */
@property (nonatomic, strong) NSArray <NSString *> *blockedAdvertisers;
/**
 Block list of applications by their platform-specific exchange- independent application identifiers. These are numeric IDs.
 */
@property (nonatomic, strong) NSArray <NSString *> *blockedApps;
/**
 Current latitude of user device.
 */
@property (nonatomic, assign) CGFloat userLatitude;
/**
 Current longitude of user device.
 */
@property (nonatomic, assign) CGFloat userLongitude;
/**
 User yob refer to OpenRTB 2.5 spec
 */
@property (nonatomic, strong) NSNumber *yearOfBirth;
/**
 User gender refer to OpenRTB 2.5 spec.
 */
@property (nonatomic, strong) NSString *gender;
/**
 User country.
 */
@property (nonatomic, strong) NSString *country;
/**
 User city.
 */
@property (nonatomic, strong) NSString *city;
/**
 User zip code.
 */
@property (nonatomic, strong) NSString *zip;
/**
 Store URL.
 */
@property (nonatomic, strong) NSURL *storeURL;
/**
 Numeric store id identifier.
 */
@property (nonatomic, strong) NSString *storeId;
/**
 Paid version of app.
 */
@property (nonatomic, assign) BOOL paid;
/**
 Bids configuration for current request.
 */
@property (nonatomic, strong) NSArray *priceFloors;


@end
