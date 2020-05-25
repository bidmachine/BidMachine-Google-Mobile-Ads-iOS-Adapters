//
//  BMADMBanner.m
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 5/18/20.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMADMBanner.h"
#import "BMADMBannerView.h"
#import <StackUIKit/StackUIKit.h>

@interface BMADMBanner ()<BMADMAdEventDelegate>

@property (nonatomic, strong) BMADMBannerView *banner;
@property (nonatomic, strong) BMADMBannerView *cachedBanner;
@property (nonatomic, assign) BOOL adOnScreen;
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSTimer *refreshTimer;
@property (nonatomic, strong) NSTimer *reloadTimer;
@property (nonatomic, strong) NSString *unitId;

@end

@implementation BMADMBanner

- (instancetype)initWithUnitId:(NSString *)unitId {
    if (self = [super init]) {
        _unitId = unitId;
    }
    return self;
}

- (void)loadAd {
    if (!self.adOnScreen && !self.cachedBanner) {
         [self cacheBanner];
    }
}

- (void)show:(UIViewController *)controller {
    self.controller = controller;
    if (!self.adOnScreen && (self.containerView || self.isLoaded)) {
        [self presentBanner];
    }
}

- (BOOL)isLoaded {
    return [self.cachedBanner isLoaded];
}

- (void)hide {
    if (self.adOnScreen) {
        [self.containerView removeFromSuperview];
        self.adOnScreen = NO;
    }
}

- (void)dealloc {
    [self.containerView removeFromSuperview];
}

#pragma mark - Private

- (void)cacheBannerIfNeeded {
    if (!self.reloadTimer) {
        self.reloadTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(cacheBanner) userInfo:nil repeats:NO];
    }
}

- (void)refreshBannerIfNeeded {
    if (!self.refreshTimer && !self.isLoaded) {
        self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(refresh) userInfo:nil repeats:NO];
    } if (self.isLoaded) {
         [self presentBanner];
    }
}

- (void)presentBanner {
    self.adOnScreen = YES;
    if (!self.containerView) {
        self.containerView = UIView.new;
    }
    if (!self.containerView.superview) {
        [self.controller.view addSubview:self.containerView];
        self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[[self.containerView.widthAnchor constraintEqualToConstant:320],
                                                  [self.containerView.heightAnchor constraintEqualToConstant:50],
                                                  [self.containerView.centerXAnchor constraintEqualToAnchor:self.controller.view.centerXAnchor],
                                                  [self.containerView.bottomAnchor constraintEqualToAnchor:self.controller.view.bottomAnchor]]];
    }
    
    if (self.isLoaded) {
        [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.banner = self.cachedBanner;
        [self.banner stk_edgesEqual:self.containerView];
        [self.banner show:self.controller];
        [self cacheBanner];
        [self refreshBannerIfNeeded];
    }
}

- (void)cacheBanner {
    self.reloadTimer = nil;
    self.cachedBanner = [BMADMBannerView new];
    self.cachedBanner.delegate = self;
    self.cachedBanner.unitId = self.unitId;
    [self.cachedBanner loadAd];
}

- (void)refresh {
    self.refreshTimer = nil;
    if (self.isLoaded) {
        [self presentBanner];
    }
}

#pragma mark - BMADMAdEventDelegate

- (void)onAdClicked {
    [self.delegate onAdClicked];
}

- (void)onAdClosed {
    [self.delegate onAdClosed];
}

- (void)onAdExpired {
    [self.delegate onAdExpired];
    [self cacheBannerIfNeeded];
}

- (void)onAdFailToLoad {
    [self.delegate onAdFailToLoad];
    [self cacheBannerIfNeeded];
}

- (void)onAdFailToPresent {
    [self.delegate onAdFailToPresent];
    [self cacheBannerIfNeeded];
}

- (void)onAdLoaded {
    if (self.adOnScreen) {
        [self refreshBannerIfNeeded];
    }
    [self.delegate onAdLoaded];
}

- (void)onAdShown {
    [self.delegate onAdShown];
}

@end
