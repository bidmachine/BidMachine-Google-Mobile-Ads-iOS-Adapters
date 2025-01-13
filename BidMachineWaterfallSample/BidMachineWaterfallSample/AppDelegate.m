//
//  
//
//  Created by BidMachine Team on 10/01/2025.
//  Copyright © 2025 BidMachine Inc. All rights reserved.

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
