//
//  Native.m
//  AdMobBidMachineSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Native.h"
#import "NativeAdRenderer.h"

#define UNIT_ID         "ca-app-pub-3216013768320747/7699763218"

@interface Native ()<BDMRequestDelegate, GADNativeAdDelegate, GADNativeAdLoaderDelegate>

@property (nonatomic, strong) GADAdLoader *nativeLoader;
@property (nonatomic, strong) GADNativeAd *nativeAd;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (nonatomic, strong) BDMNativeAdRequest *request;

@end

@implementation Native

- (void)loadAd:(id)sender {
    [self switchState:BSStateLoading];
    
    [NativeAdRenderer unregister:self.nativeAd fromView:self.container];
    self.nativeAd = nil;
    
    self.request = [BDMNativeAdRequest new];
    [self.request performWithDelegate:self];
}

- (void)showAd:(id)sender {
    [self switchState:BSStateIdle];
    self.nativeAd.delegate = self;
    self.nativeAd.rootViewController = self;
    [NativeAdRenderer renderAd:self.nativeAd onView:self.container];
}

- (GADAdLoader *)nativeLoader {
    if (!_nativeLoader) {
        _nativeLoader = [[GADAdLoader alloc] initWithAdUnitID:@UNIT_ID
                                           rootViewController:self
                                                      adTypes:@[GADAdLoaderAdTypeNative]
                                                      options:@[self.viewOptions, self.videoOptions, self.mediaOptions]];
        _nativeLoader.delegate = self;
    }
    return _nativeLoader;
}

- (GADAdLoaderOptions *)videoOptions {
    GADVideoOptions *options = GADVideoOptions.new;
    options.startMuted = YES;
    return options;
}

- (GADAdLoaderOptions *)mediaOptions {
    GADNativeAdMediaAdLoaderOptions *options = GADNativeAdMediaAdLoaderOptions.new;
    options.mediaAspectRatio = GADMediaAspectRatioLandscape;
    return options;
}

- (GADAdLoaderOptions *)viewOptions {
    GADNativeAdViewAdOptions *options = GADNativeAdViewAdOptions.new;
    options.preferredAdChoicesPosition = GADAdChoicesPositionTopRightCorner;
    return options;
}

- (void)makeRequest {
    GADRequest *request = [GADRequest request];
    [self.nativeLoader loadRequest:request];
}

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
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

- (void)requestDidExpire:(BDMRequest *)request {
    // In case request expired we can release it
    // and build some retry logic
}

#pragma mark - GADUnifiedNativeAdLoaderDelegate

- (void)adLoader:(nonnull GADAdLoader *)adLoader didFailToReceiveAdWithError:(nonnull NSError *)error {
    [self switchState:BSStateIdle];
}

- (void)adLoaderDidFinishLoading:(nonnull GADAdLoader *)adLoader {
    
}

- (void)adLoader:(nonnull GADAdLoader *)adLoader didReceiveNativeAd:(nonnull GADNativeAd *)nativeAd {
    [self switchState:BSStateReady];
    self.nativeAd = nativeAd;
    self.nativeAd.delegate = self;
}

#pragma mark - GADNativeAdDelegate

- (void)nativeAdDidRecordImpression:(nonnull GADNativeAd *)nativeAd {
    
}

- (void)nativeAdDidRecordClick:(nonnull GADNativeAd *)nativeAd {
    
}

@end
