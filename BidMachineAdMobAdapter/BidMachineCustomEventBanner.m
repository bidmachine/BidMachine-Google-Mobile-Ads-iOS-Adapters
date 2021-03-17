//
//  BidMachineCustomEventBanner.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "BidMachineCustomEventBanner.h"

@import BidMachine;
@import StackFoundation;

#import "BDMExternalAdapterRequestController.h"

@interface BidMachineCustomEventBanner () <BDMBannerDelegate, BDMAdEventProducerDelegate, BDMExternalAdapterRequestControllerDelegate>

@property (nonatomic, strong) BDMBannerView *bannerView;
@property (nonatomic, strong) BDMExternalAdapterRequestController *requestController;

@end


@implementation BidMachineCustomEventBanner

- (void)requestBannerAd:(GADAdSize)adSize
              parameter:(NSString *)serverParameter
                  label:(NSString *)serverLabel
                request:(GADCustomEventRequest *)request
{
    [self.requestController prepareRequestWithConfiguration:[BDMExternalAdapterConfiguration configurationWithBuilder:^(id<BDMExternalAdapterConfigurationBuilderProtocol> builder) {
        builder.appendJsonConfiguration([STKJSONSerialization JSONObjectWithData:[serverParameter dataUsingEncoding:NSUTF8StringEncoding]
                                                                         options:NSJSONReadingAllowFragments
                                                                           error:nil]);
        builder.appendAdSize(CGSizeFromGADAdSize(adSize));
    }]];
}

#pragma mark - Lazy

- (BDMBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [BDMBannerView new];
        _bannerView.rootViewController = self.delegate.viewControllerForPresentingModalView;
        _bannerView.delegate = self;
        _bannerView.producerDelegate = self;
    }
    return _bannerView;
}

- (BDMExternalAdapterRequestController *)requestController {
    if (!_requestController) {
        _requestController = [[BDMExternalAdapterRequestController alloc] initWithType:BDMInternalPlacementTypeBanner
                                                                              delegate:self];
    }
    return _requestController;
}

#pragma mark - BDMExternalAdapterRequestControllerDelegate

- (void)controller:(BDMExternalAdapterRequestController *)controller didPrepareRequest:(BDMRequest *)request {
    BDMBannerRequest *adRequest = (BDMBannerRequest *)request;
    [self.bannerView setFrame:(CGRect){.size = CGSizeFromBDMSize(adRequest.adSize)}];
    [self.bannerView populateWithRequest:adRequest];
}

- (void)controller:(BDMExternalAdapterRequestController *)controller didFailPrepareRequest:(NSError *)error {
    [self.delegate customEventBanner:self didFailAd:error];
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
    [self.delegate customEventBannerWillDismissModal:self];
    [self.delegate customEventBannerDidDismissModal:self];
}

#pragma mark - BDMAdEventProducerDelegate

// Currently noop
- (void)didProduceImpression:(id<BDMAdEventProducer>)producer {}
- (void)didProduceUserAction:(id<BDMAdEventProducer>)producer {}

@end
