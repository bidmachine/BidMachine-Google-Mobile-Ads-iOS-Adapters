//
//  BMADMRewardedAd.m
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 25.05.2020.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMADMRewardedAd.h"
#import "BMADMFetcher.h"
#import <BidMachine/BidMachine.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface BMADMRewardedAd()<BDMRewardedDelegate, BDMRequestDelegate, GADRewardedAdMetadataDelegate>

@property (nonatomic, strong) BDMRewarded *rewarded;
@property (nonatomic, strong) GADRewardedAd *adMobRewarded;
@property (nonatomic, strong) BDMRewardedRequest *rewardedRequest;
@property (nonatomic, strong) NSString *unitId;

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
    [self.rewardedRequest performWithDelegate:self];
}

- (void)show:(UIViewController *)controller {
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

#pragma mark - BDMRewardedDelegate

- (void)rewardedReadyToPresent:(nonnull BDMRewarded *)rewarded {
    [self.delegate onAdLoaded];
}

- (void)rewarded:(nonnull BDMRewarded *)rewarded failedWithError:(nonnull NSError *)error {
    [self.delegate onAdFailToLoad];
}

- (void)rewarded:(nonnull BDMRewarded *)rewarded failedToPresentWithError:(nonnull NSError *)error {
    [self.delegate onAdFailToPresent];
}

- (void)rewardedWillPresent:(nonnull BDMRewarded *)rewarded {
    [self.delegate onAdShown];
}

- (void)rewardedDidDismiss:(nonnull BDMRewarded *)rewarded {
    [self.delegate onAdClosed];
}

- (void)rewardedRecieveUserInteraction:(nonnull BDMRewarded *)rewarded {
    [self.delegate onAdClicked];
}

- (void)rewardedFinishRewardAction:(nonnull BDMRewarded *)rewarded {
    [self.delegate onAdRewarded];
}

- (void)interstitialDidExpire:(nonnull BDMInterstitial *)interstitial {
    [self.delegate onAdExpired];
}

#pragma mark - BDMRequestDelegate

- (void)request:(nonnull BDMRequest *)request completeWithInfo:(nonnull BDMAuctionInfo *)info {
    if (info.price.doubleValue <= 25) {
        [BMADMFetcher.shared setFormat:@"5.0"];
    } else {
        [BMADMFetcher.shared setFormat:@"1000.0"];
    }
    
    __weak __typeof__(self) weakSelf = self;
    DFPRequest *adMobRequest = [DFPRequest request];
    adMobRequest.customTargeting = [BMADMFetcher.shared fetchParamsFromRequest:self.rewardedRequest];
    [self.adMobRewarded loadRequest:adMobRequest completionHandler:^(GADRequestError * _Nullable error) {
        if (error) {
            [weakSelf.delegate onAdFailToLoad];
        }
    }];
}

- (void)request:(nonnull BDMRequest *)request failedWithError:(nonnull NSError *)error {
    [self.delegate onAdFailToLoad];
}

- (void)requestDidExpire:(nonnull BDMRequest *)request {
    [self.delegate onAdExpired];
}

#pragma mark - GADRewardedAdMetadataDelegate

- (void)rewardedAdMetadataDidChange:(nonnull GADRewardedAd *)rewardedAd {
    if (![rewardedAd.adMetadata[@"AdTitle"] isEqual:@"bidmachine-rewarded"]) {
        [self.delegate onAdFailToLoad];
    } else {
        [self.rewarded populateWithRequest:self.rewardedRequest];
    }
}

@end
