//
//  BidMachineCustomEventBanner.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "BidMachineCustomEventBanner.h"
#import "GADBidMachineUtils+Request.h"
#import <BidMachine/BidMachine.h>


@interface BidMachineCustomEventBanner () <BDMBannerDelegate>

@property (nonatomic, strong) BDMBannerView *bannerView;

@end


@implementation BidMachineCustomEventBanner

- (void)requestBannerAd:(GADAdSize)adSize
              parameter:(nullable NSString *)serverParameter
                  label:(nullable NSString *)serverLabel
                request:(GADCustomEventRequest *)request {
    __weak typeof(self) weakSelf = self;
    NSDictionary *requestInfo = [[GADBidMachineUtils sharedUtils] requestInfoFrom:serverParameter request:request];
    [[GADBidMachineUtils sharedUtils] initializeBidMachineWithRequestInfo:requestInfo completion:^(NSError *error) {
        BDMBannerAdSize size = BDMBannerAdSizeFromGADAdSize(adSize);
        BDMBannerRequest *bannerRequest = [[GADBidMachineUtils sharedUtils] bannerRequestWithSize:size requestInfo:requestInfo];
        weakSelf.bannerView.delegate = weakSelf;
        [weakSelf.bannerView setFrame:CGRectMake(0, 0, adSize.size.width, adSize.size.height)];
        [weakSelf.bannerView populateWithRequest:bannerRequest];
    }];
}

#pragma mark - Lazy

- (BDMBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [BDMBannerView new];
    }
    return _bannerView;
}

#pragma mark - BDMBannerDelegate

- (void)bannerViewReadyToPresent:(BDMBannerView *)bannerView {
    [self.delegate customEventBanner:self didReceiveAd:bannerView];
}

- (void)bannerView:(BDMBannerView *)bannerView failedWithError:(NSError *)error {
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)bannerViewRecieveUserInteraction:(BDMBannerView *)bannerView {
    [self.delegate customEventBannerWasClicked:self];
}

- (void)bannerViewWillLeaveApplication:(BDMBannerView *)bannerView {
    [self.delegate customEventBannerWillLeaveApplication:self];
}

- (void)bannerViewWillPresentScreen:(BDMBannerView *)bannerView {
    [self.delegate customEventBannerWillPresentModal:self];
}

- (void)bannerViewDidDismissScreen:(BDMBannerView *)bannerView {
    [self.delegate customEventBannerDidDismissModal:self];
}

@end
