//
//  BMADMRewardedAd.m
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 25.05.2020.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMADMRewardedAd.h"
#import "BMADMFetcher.h"
#import "BMADMNetworkEvent.h"
#import <BidMachine/BidMachine.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface BMADMRewardedAd()<BDMRewardedDelegate, BDMRequestDelegate, GADRewardedAdMetadataDelegate>

@property (nonatomic, strong) BDMRewarded *rewarded;
@property (nonatomic, strong) GADRewardedAd *adMobRewarded;
@property (nonatomic, strong) BDMRewardedRequest *rewardedRequest;
@property (nonatomic, strong) NSString *unitId;
@property (nonatomic, strong) BMADMNetworkEvent *event;

@end

@implementation BMADMRewardedAd

- (instancetype)initWithUnitId:(NSString *)unitId {
    if (self = [super init]) {
        _unitId = unitId;
    }
    return self;
}

- (void)loadAd {
    [self clean];
    self.event.request = self.rewardedRequest;
    [self.rewardedRequest performWithDelegate:self];
    [self.event trackEvent:BMADMEventBMRequestStart customParams:nil];
}

- (void)show:(UIViewController *)controller {
    [self.event trackEvent:BMADMEventBMShow customParams:nil];
    [self.rewarded presentFromRootViewController:controller];
}

- (BOOL)isLoaded {
    return [self.rewarded isLoaded];
}

#pragma mark - Private

- (void)clean {
    self.rewarded = nil;
    self.adMobRewarded = nil;
    self.rewardedRequest = nil;
}

- (BDMRewardedRequest *)rewardedRequest {
    if (!_rewardedRequest) {
        _rewardedRequest = [BDMRewardedRequest new];
    }
    return _rewardedRequest;
}

- (BDMRewarded *)rewarded {
    if (!_rewarded) {
        _rewarded = [BDMRewarded new];
        _rewarded.delegate = self;
    }
    return _rewarded;
}

- (GADRewardedAd *)adMobRewarded {
    if (!_adMobRewarded) {
        _adMobRewarded = [[GADRewardedAd alloc] initWithAdUnitID:self.unitId];
        _adMobRewarded.adMetadataDelegate = self;
    }
    return _adMobRewarded;
}

- (BMADMNetworkEvent *)event {
    if (!_event) {
        _event = BMADMNetworkEvent.new;
        _event.adType = BMADMEventTypeRewarded;
    }
    return _event;
}

#pragma mark - BDMRewardedDelegate

- (void)rewardedReadyToPresent:(nonnull BDMRewarded *)rewarded {
    [self.event trackEvent:BMADMEventBMLoaded customParams:nil];
    [self.delegate onAdLoaded];
}

- (void)rewarded:(nonnull BDMRewarded *)rewarded failedWithError:(nonnull NSError *)error {
    [self.event trackError:error event:BMADMEventBMFailToLoad customParams:nil internal:NO];
    [self.delegate onAdFailToLoad];
}

- (void)rewarded:(nonnull BDMRewarded *)rewarded failedToPresentWithError:(nonnull NSError *)error {
    [self.event trackError:error event:BMADMEventBMFailToShow customParams:nil internal:NO];
    [self.delegate onAdFailToPresent];
}

- (void)rewardedWillPresent:(nonnull BDMRewarded *)rewarded {
    [self.event trackEvent:BMADMEventBMShown customParams:nil];
    [self.delegate onAdShown];
}

- (void)rewardedDidDismiss:(nonnull BDMRewarded *)rewarded {
    [self.event trackEvent:BMADMEventBMClosed customParams:nil];
    [self.delegate onAdClosed];
}

- (void)rewardedRecieveUserInteraction:(nonnull BDMRewarded *)rewarded {
    [self.event trackEvent:BMADMEventBMClicked customParams:nil];
    [self.delegate onAdClicked];
}

- (void)rewardedFinishRewardAction:(nonnull BDMRewarded *)rewarded {
    [self.event trackEvent:BMADMEventBMReward customParams:nil];
    [self.delegate onAdRewarded];
}

- (void)interstitialDidExpire:(nonnull BDMInterstitial *)interstitial {
    [self.event trackEvent:BMADMEventBMExpired customParams:nil];
    [self.delegate onAdExpired];
}

#pragma mark - BDMRequestDelegate

- (void)request:(nonnull BDMRequest *)request completeWithInfo:(nonnull BDMAuctionInfo *)info {
    [self.event trackEvent:BMADMEventBMRequestSuccess customParams:nil];
    if (info.price.doubleValue <= 25) {
        [BMADMFetcher.shared setFormat:@"5.0"];
    } else {
        [BMADMFetcher.shared setFormat:@"1000.0"];
    }
    
    __weak __typeof__(self) weakSelf = self;
    DFPRequest *adMobRequest = [DFPRequest request];
    adMobRequest.customTargeting = [BMADMFetcher.shared fetchParamsFromRequest:self.rewardedRequest];
    [self.event trackEvent:BMADMEventGAMLoadStart customParams:adMobRequest.customTargeting];
    [self.adMobRewarded loadRequest:adMobRequest completionHandler:^(GADRequestError * _Nullable error) {
        if (error) {
            [self.event trackError:error event:BMADMEventGAMFailToLoad customParams:nil internal:YES];
            [weakSelf.delegate onAdFailToLoad];
        } else {
            [self.event trackEvent:BMADMEventGAMLoaded customParams:nil];
        }
    }];
}

- (void)request:(nonnull BDMRequest *)request failedWithError:(nonnull NSError *)error {
    [self.event trackError:error event:BMADMEventBMRequestFail customParams:nil internal:NO];
    [self.delegate onAdFailToLoad];
}

- (void)requestDidExpire:(nonnull BDMRequest *)request {
    [self.event trackEvent:BMADMEventBMExpired customParams:nil];
    [self.delegate onAdExpired];
}

#pragma mark - GADRewardedAdMetadataDelegate

- (void)rewardedAdMetadataDidChange:(nonnull GADRewardedAd *)rewardedAd {
    [self.event trackEvent:BMADMEventGAMAppEvent customParams:nil];
    if (![rewardedAd.adMetadata[@"AdTitle"] isEqual:@"bidmachine-rewarded"]) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:500 userInfo:nil];
        [self.event trackError:error event:BMADMEventGAMFailToLoad customParams:nil internal:YES];
        [self.delegate onAdFailToLoad];
    } else {
        [self.event trackEvent:BMADMEventBMLoadStart customParams:nil];
        [self.rewarded populateWithRequest:self.rewardedRequest];
    }
}

@end
