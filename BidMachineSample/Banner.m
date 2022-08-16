//
//  Banner.m
//  AdMobBidMachineSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Banner.h"

#define UNIT_ID         "ca-app-pub-3216013768320747/5715655753"

@interface Banner ()<BDMRequestDelegate, GADBannerViewDelegate>

@property (nonatomic, strong) BDMBannerRequest *request;
@property (nonatomic, strong) GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation Banner

- (void)loadAd:(id)sender {
    [self switchState:BSStateLoading];
    
    self.bannerView = nil;
    self.request = [BDMBannerRequest new];
    [self.request performWithDelegate:self];
}

- (void)showAd:(id)sender {
    [self switchState:BSStateIdle];
    [self addBannerInContainer];
}

- (void)makeRequest {
    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
}

- (void)addBannerInContainer {
    [self.container.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.container addSubview:self.bannerView];
    
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.bannerView.centerXAnchor constraintEqualToAnchor:self.container.centerXAnchor] setActive:YES];
    [[self.bannerView.centerYAnchor constraintEqualToAnchor:self.container.centerYAnchor] setActive:YES];
}

#pragma mark - lazy

- (GADBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeBanner];
        _bannerView.delegate = self;
        _bannerView.adUnitID = @UNIT_ID;
        _bannerView.rootViewController = self;
        _bannerView.translatesAutoresizingMaskIntoConstraints = YES;
        _bannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _bannerView;
}

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithAd:(id<BDMAdProtocol>)adObject {
    // After request complete loading application can lost strong ref on it
    // BDMRequestStorage will capture request by itself
    self.request = nil;
    // Save request for bid
    [BDMRequestStorage.shared saveRequest:request];
    // Here we define which Admob ad should be loaded
    [self makeRequest];
}

- (void)request:(BDMRequest *)request failedWithError:(NSError *)error {
    // In case request failed we can release it
    // and build some retry logic
    self.request = nil;
    [self switchState:BSStateIdle];
}

- (void)request:(BDMRequest *)request didExpireAd:(id<BDMAdProtocol>)adObject {
    // In case request expired we can release it
    // and build some retry logic
}

#pragma mark - GADBannerViewDelegate

- (void)bannerViewDidReceiveAd:(nonnull GADBannerView *)bannerView {
    [self switchState:BSStateReady];
}

- (void)bannerView:(nonnull GADBannerView *)bannerView didFailToReceiveAdWithError:(nonnull NSError *)error {
    [self switchState:BSStateIdle];
}

- (void)bannerViewDidRecordImpression:(nonnull GADBannerView *)bannerView {
    
}

- (void)bannerViewDidRecordClick:(nonnull GADBannerView *)bannerView {
    
}

- (void)bannerViewWillPresentScreen:(nonnull GADBannerView *)bannerView {
    
}

- (void)bannerViewWillDismissScreen:(nonnull GADBannerView *)bannerView {
    
}

- (void)bannerViewDidDismissScreen:(nonnull GADBannerView *)bannerView {
    
}

@end
