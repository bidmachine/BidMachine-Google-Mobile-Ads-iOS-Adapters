//
//  Banner.m
//  AdMobBidMachineSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Banner.h"

#define UNIT_ID         "ca-app-pub-3940256099942544/2435281174"

@interface Banner ()<GADBannerViewDelegate>

@property (nonatomic, strong) GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation Banner

- (void)loadAd:(id)sender {
    self.bannerView = nil;
    [self.container.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self switchState:BSStateLoading];
    [self makeRequest];
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
