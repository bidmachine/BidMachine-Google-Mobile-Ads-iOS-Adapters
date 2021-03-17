//
//  BidMachineCustomEventNativeAd.m
//  BidMachineAdapter
//
//  Created by Ilia Lozhkin on 11/18/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "BidMachineCustomEventNativeAd.h"
#import "BidMachineUnifiedNativeAd.h"

@import BidMachine;
@import StackFoundation;

#import "BDMExternalAdapterRequestController.h"


@interface BidMachineCustomEventNativeAd()<BDMNativeAdDelegate, BDMExternalAdapterRequestControllerDelegate>

@property (nonatomic, strong) BDMNativeAd *nativeAd;
@property (nonatomic, strong) BDMExternalAdapterRequestController *requestController;

@end

@implementation BidMachineCustomEventNativeAd

- (void)requestNativeAdWithParameter:(nonnull NSString *)serverParameter
                             request:(nonnull GADCustomEventRequest *)request
                             adTypes:(nonnull NSArray *)adTypes
                             options:(nonnull NSArray *)options
                  rootViewController:(nonnull UIViewController *)rootViewController
{
    [self.requestController prepareRequestWithConfiguration:[BDMExternalAdapterConfiguration configurationWithBuilder:^(id<BDMExternalAdapterConfigurationBuilderProtocol> builder) {
            builder.appendJsonConfiguration([STKJSONSerialization JSONObjectWithData:[serverParameter dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options:NSJSONReadingAllowFragments
                                                                               error:nil]);
    }]];
}

- (BOOL)handlesUserClicks {
    return true;
}

- (BOOL)handlesUserImpressions {
    return true;
}

#pragma mark - lazy

- (BDMNativeAd *)nativeAd {
    if (!_nativeAd) {
        _nativeAd = BDMNativeAd.new;
        _nativeAd.delegate = self;
    }
    return _nativeAd;
}

- (BDMExternalAdapterRequestController *)requestController {
    if (!_requestController) {
        _requestController = [[BDMExternalAdapterRequestController alloc] initWithType:BDMInternalPlacementTypeNative
                                                                              delegate:self];
    }
    return _requestController;
}

#pragma mark - BDMExternalAdapterRequestControllerDelegate

- (void)controller:(BDMExternalAdapterRequestController *)controller didPrepareRequest:(BDMRequest *)request {
    BDMNativeAdRequest *adRequest = (BDMNativeAdRequest *)request;
    [self.nativeAd makeRequest:adRequest];
}

- (void)controller:(BDMExternalAdapterRequestController *)controller didFailPrepareRequest:(NSError *)error {
    [self.delegate customEventNativeAd:self didFailToLoadWithError:error];
}

 
#pragma mark - BDMNativeAdDelegate

- (void)nativeAd:(nonnull BDMNativeAd *)nativeAd failedWithError:(nonnull NSError *)error {
    [self.delegate customEventNativeAd:self didFailToLoadWithError:error];
}

- (void)nativeAd:(nonnull BDMNativeAd *)nativeAd readyToPresentAd:(nonnull BDMAuctionInfo *)auctionInfo {
    BidMachineUnifiedNativeAd *adapter = [[BidMachineUnifiedNativeAd alloc] initWithNativeAd:nativeAd];
    [self.delegate customEventNativeAd:self didReceiveMediatedUnifiedNativeAd:adapter];
}

@end
