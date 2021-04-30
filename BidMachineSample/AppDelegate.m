//
//  AppDelegate.m
//  AdMobBidMachineSample
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "AppDelegate.h"
#import <BidMachine/BidMachine.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@import BidMachine;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    __weak typeof(self) weakSelf = self;
    [self startBidMachine:^{
        [weakSelf startAdMob];
    }];
    return YES;
}

/// Start BidMachine session, should be called before AdMob initialisation
- (void)startBidMachine:(void(^)(void))completion {
    BDMSdkConfiguration *config = [BDMSdkConfiguration new];
    config.targeting = BDMTargeting.new;
    config.targeting.storeId = @"12345";
    config.testMode = YES;
    [BDMSdk.sharedSdk startSessionWithSellerID:@"5"
                                 configuration:config
                                    completion:completion];
}

///  Start AdMob SDK
- (void)startAdMob {
   [[GADMobileAds sharedInstance] startWithCompletionHandler:^(GADInitializationStatus * _Nonnull status) {
        NSDictionary *statuses = status.adapterStatusesByClassName;
        NSLog(@"%@", [statuses.allKeys componentsJoinedByString:@","]);
    }];
}

@end
