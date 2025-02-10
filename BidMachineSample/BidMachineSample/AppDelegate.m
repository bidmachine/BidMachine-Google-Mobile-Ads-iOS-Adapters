//
//  AppDelegate.m
//  AdMobBidMachineSample
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@import BidMachine;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [BidMachineSdk.shared populate:^(id<BidMachineInfoBuilderProtocol> builder) {
            [builder withTestMode:YES];
            [builder withLoggingMode:YES];
            [builder withBidLoggingMode:YES];
            [builder withEventLoggingMode:YES];
    }];
    
    [BidMachineSdk.shared initializeSdk: @"154"];
    [self startAdMob];
    return YES;
}

- (void)startAdMob {
   [[GADMobileAds sharedInstance] startWithCompletionHandler:^(GADInitializationStatus * _Nonnull status) {
        NSDictionary *statuses = status.adapterStatusesByClassName;
        NSLog(@"%@", [statuses.allKeys componentsJoinedByString:@","]);
    }];
}

@end
