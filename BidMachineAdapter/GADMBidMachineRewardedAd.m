//
//  GADMBidMachineRewardedAd.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/15/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADMBidMachineRewardedAd.h"
#import "GADBidMachineNetworkExtras.h"
#import "GADBidMachineUtils+Request.h"
#import <BidMachine/BidMachine.h>

@interface GADMBidMachineRewardedAd() <BDMRewardedDelegate>

@property (nonatomic, weak) id<GADMRewardBasedVideoAdNetworkConnector> rewardedAdConnector;
@property (nonatomic, strong) BDMRewarded *rewardedAd;

@end

@implementation GADMBidMachineRewardedAd

+ (NSString *)adapterVersion {
    return @"1.0.3.0";
}

+ (Class<GADAdNetworkExtras>)networkExtrasClass {
    return GADBidMachineNetworkExtras.class;
}

- (instancetype)initWithRewardBasedVideoAdNetworkConnector:(id<GADMRewardBasedVideoAdNetworkConnector>)connector {
    if (!connector) {
        return nil;
    }
    self = [super init];
    if (self) {
        _rewardedAdConnector = connector;
    }
    return self;
}

- (void)setUp {
    id<GADMRewardBasedVideoAdNetworkConnector> strongConnector = self.rewardedAdConnector;
    NSDictionary *serverInfo = [[GADBidMachineUtils sharedUtils] getRequestInfoFromConnector:strongConnector];
    NSString *sellerId = [serverInfo[@"seller_id"] stringValue];
    BOOL testModeEnabled = [serverInfo[@"test_mode"] boolValue];
    BOOL loggingEnabled = [serverInfo[@"logging_enabled"] boolValue];
    if (sellerId) {
        BDMSdkConfiguration *config = [BDMSdkConfiguration new];
        [config setTestMode:testModeEnabled];
        [[BDMSdk sharedSdk] setEnableLogging:loggingEnabled];
        [[BDMSdk sharedSdk] startSessionWithSellerID:sellerId configuration:config completion:^{
            NSLog(@"BidMachine SDK was successfully initialized!");
            [self.rewardedAdConnector adapterDidSetUpRewardBasedVideoAd:self];
        }];
    }
}

- (void)requestRewardBasedVideoAd {
    self.rewardedAd.delegate = self;
    BDMRewardedRequest *request = [[GADBidMachineUtils sharedUtils] rewardedRequestWithConnector:self.rewardedAdConnector];
    [self.rewardedAd populateWithRequest:request];
}

- (void)presentRewardBasedVideoAdWithRootViewController:(UIViewController *)viewController {
    [self.rewardedAd presentFromRootViewController:viewController];
}

- (void)stopBeingDelegate {
    [self.rewardedAd setDelegate:nil];
}

#pragma mark - Lazy

- (BDMRewarded *)rewardedAd {
    if (!_rewardedAd) {
        _rewardedAd = [BDMRewarded new];
    }
    return _rewardedAd;
}

#pragma mark - BDMRewardedDelegatge

- (void)rewardedReadyToPresent:(nonnull BDMRewarded *)rewarded {
    [self.rewardedAdConnector adapterDidReceiveRewardBasedVideoAd:self];
}

- (void)rewarded:(nonnull BDMRewarded *)rewarded failedWithError:(nonnull NSError *)error {
    [self.rewardedAdConnector adapter:self didFailToLoadRewardBasedVideoAdwithError:error];
}

- (void)rewardedRecieveUserInteraction:(nonnull BDMRewarded *)rewarded {
    [self.rewardedAdConnector adapterDidGetAdClick:self];
}

- (void)rewarded:(nonnull BDMRewarded *)rewarded failedToPresentWithError:(nonnull NSError *)error {
    
}

- (void)rewardedWillPresent:(nonnull BDMRewarded *)rewarded {
    [self.rewardedAdConnector adapterDidOpenRewardBasedVideoAd:self];
}

- (void)rewardedDidDismiss:(nonnull BDMRewarded *)rewarded {
    [self.rewardedAdConnector adapterDidCloseRewardBasedVideoAd:self];
}

- (void)rewardedFinishRewardAction:(nonnull BDMRewarded *)rewarded {
    
}

@end
