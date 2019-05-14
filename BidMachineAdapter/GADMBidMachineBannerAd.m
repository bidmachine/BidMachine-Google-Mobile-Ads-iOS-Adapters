//
//  GADMBidMachineBannerAd.m
//  BidMachineAdapter
//
//  Created by Yaroslav Skachkov on 5/14/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "GADMBidMachineBannerAd.h"
#import "GADBidMachineUtils.h"

@interface GADMBidMachineBannerAd()

@property (nonatomic, strong) BDMBannerView *bannerView;
@property (nonatomic, weak) id<GADMAdNetworkConnector> connector;
@property (nonatomic, weak) id<GADMAdNetworkAdapter> adapter;

@end

@implementation GADMBidMachineBannerAd

- (instancetype)initWithConnector:(id<GADMAdNetworkConnector>)connector adapter:(id<GADMAdNetworkAdapter>)adapter {
    self = [super init];
    if (self) {
        self.bannerView.delegate = adapter;
        _connector = connector;
        _adapter = adapter;
    }
    return self;
}
- (void)getBannerWithSize:(GADAdSize)adSize {
    
}

#pragma mark - Lazy

- (BDMBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [BDMBannerView new];
    }
    return _bannerView;
}

@end
