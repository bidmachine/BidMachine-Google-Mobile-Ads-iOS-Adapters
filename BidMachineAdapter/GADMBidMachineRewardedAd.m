//
//  GADMBidMachineRewardedAd.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/15/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADMBidMachineRewardedAd.h"
#import "GADMAdapterBidMachineConstants.h"
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
    NSString *sellerID = serverInfo[kBidMachineSellerId];
    if (sellerID) {
        BOOL testModeEnabled = [serverInfo[kBidMachineTestMode] boolValue];
        BOOL loggingEnabled = [serverInfo[kBidMachineLoggingEnabled] boolValue];
        BDMSdkConfiguration *config = [BDMSdkConfiguration new];
        [config setTestMode:testModeEnabled];
        [[BDMSdk sharedSdk] setEnableLogging:loggingEnabled];
        [[BDMSdk sharedSdk] startSessionWithSellerID:sellerID configuration:config completion:^{
            NSLog(@"BidMachine SDK was successfully initialized!");
            [self.rewardedAdConnector adapterDidSetUpRewardBasedVideoAd:self];
        }];
    } else {
        NSString *description = @"BidMachine's initialization skipped. The sellerId is empty or has an incorrect type.";
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : description,
                                   NSLocalizedFailureReasonErrorKey : description};
        NSError *error = [NSError errorWithDomain:@"com.google.mediation.bidmachine" code:0 userInfo:userInfo];
        [self.rewardedAdConnector adapter:self didFailToSetUpRewardBasedVideoAdWithError:error];
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
    // The Google Mobile Ads SDK does not have an equivalent callback.
    NSLog(@"Rewarded failed to present!");
}

- (void)rewardedWillPresent:(nonnull BDMRewarded *)rewarded {
    [self.rewardedAdConnector adapterDidOpenRewardBasedVideoAd:self];
}

- (void)rewardedDidDismiss:(nonnull BDMRewarded *)rewarded {
    [self.rewardedAdConnector adapterDidCloseRewardBasedVideoAd:self];
}

- (void)rewardedFinishRewardAction:(nonnull BDMRewarded *)rewarded {
    GADAdReward *reward = [[GADAdReward alloc] initWithRewardType:@"" rewardAmount:[NSDecimalNumber one]];
    [self.rewardedAdConnector adapter:self didRewardUserWithReward:reward];
}

@end