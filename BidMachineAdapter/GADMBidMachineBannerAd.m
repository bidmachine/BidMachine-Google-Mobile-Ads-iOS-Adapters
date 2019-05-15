//
//  GADMBidMachineBannerAd.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADMBidMachineBannerAd.h"
#import "GADBidMachineUtils+Request.h"
#import <BidMachine/BidMachine.h>

@interface GADMBidMachineBannerAd() <BDMBannerDelegate>

@property (nonatomic, strong) BDMBannerView *bannerView;
@property (nonatomic, weak) id<GADMAdNetworkConnector> connector;
@property (nonatomic, weak) id<GADMAdNetworkAdapter> adapter;

@end

@implementation GADMBidMachineBannerAd

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

- (void)requestBannerAd:(GADAdSize)adSize
              parameter:(nullable NSString *)serverParameter
                  label:(nullable NSString *)serverLabel
                request:(nonnull GADCustomEventRequest *)request {
    [self initializeBidMachineWith:serverParameter request:request];
    self.bannerView.delegate = self;
    BDMBannerAdSize size = [[GADBidMachineUtils sharedUtils] getBannerAdSizeFrom:adSize];
    CGSize cgSize = CGSizeFromBDMSize(size);
    BDMBannerRequest *bannerRequest = [[GADBidMachineUtils sharedUtils] setupBannerRequestWithSize:size serverParameter:serverParameter request:request];
    [self.bannerView setFrame:CGRectMake(0, 0, cgSize.width, cgSize.height)];
    [self.bannerView populateWithRequest:bannerRequest];
}

#pragma mark - Lazy

- (BDMBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [BDMBannerView new];
    }
    return _bannerView;
}

- (void)bannerView:(nonnull BDMBannerView *)bannerView failedWithError:(nonnull NSError *)error {
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)bannerViewReadyToPresent:(nonnull BDMBannerView *)bannerView {
    [self.delegate customEventBanner:self didReceiveAd:bannerView];
}

- (void)bannerViewRecieveUserInteraction:(nonnull BDMBannerView *)bannerView {
    [self.delegate customEventBannerWasClicked:self];
}

- (void)bannerViewDidDismissScreen:(BDMBannerView *)bannerView {
//    [self.delegate custom];
}

- (void)bannerViewWillLeaveApplication:(BDMBannerView *)bannerView {
    [self.delegate customEventBannerWillLeaveApplication:self];
}

- (void)bannerViewWillPresentScreen:(BDMBannerView *)bannerView {
    [self.delegate customEventBannerWillPresentModal:self];
}

@end
