![BidMachine iOS](https://appodeal-ios.s3-us-west-1.amazonaws.com/docs/bidmachine.png)

# BidMachine IOS AdMob Bidding Sample

- [Getting Started](#user-content-getting-started)
- [Initialize sdk](#user-content-initialize-sdk)
- [Banner implementation](#user-content-banner-implementation)
- [Interstitial implementation](#user-content-interstitial-implementation)
- [Rewarded implementation](#user-content-rewarded-implementation)
- [Native ad implementation](#user-content-native-ad-implementation)
- [Changelog](BidMachineSpecs/CHANGELOG.md)

## Getting Started

##### Add following lines into your project Podfile

> **_NOTE:_** In 2.0 + version needed use BidMachineAdMobAdapter spec name

```ruby
target 'Target' do
  project 'Project.xcodeproj'
  pod 'BidMachineAdMobAdapter', '~> 2.1.1.0'
end
```

### Initialize sdk

> **_WARNING:_** Before initialize AdMob sdk you should start BM sdk. 

``` objc
    [BidMachineSdk.shared populate:^(id<BidMachineInfoBuilderProtocol> builder) {
            [builder withTestMode:YES];
            [builder withLoggingMode:YES];
            [builder withBidLoggingMode:YES];
            [builder withEventLoggingMode:YES];
    }];
    
    [BidMachineSdk.shared initializeSdk: @"1"];

    [[GADMobileAds sharedInstance] startWithCompletionHandler:^(GADInitializationStatus * _Nonnull status) {
            NSDictionary *statuses = status.adapterStatusesByClassName;
            NSLog(@"%@", [statuses.allKeys componentsJoinedByString:@","]);
    }];
```

### Banner implementation

Before start loading Admob you should load Bidmachine ad and save it to store

> **_NOTE:_** For some banners you should use some placment (BidMachinePlacementFormatBanner320x50, BidMachinePlacementFormatBanner300x250)

```objc

@import BidMachine;
@import BidMachineApiCore;
@import BidMachineAdMobAdapter;

- (void)before {
    __weak typeof(self) weakSelf = self;
    id<BidMachineRequestConfigurationProtocol> config = [BidMachineSdk.shared requestConfiguration:BidMachinePlacementFormatBanner320x50 error:nil];
    [BidMachineSdk.shared banner:config :^(BidMachineBanner *ad, NSError *error) {
        [BidMachineAdMobAdapter store:ad]; 
        [weakSelf after];
    }];
}

- (void)after {
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner]; // kGADAdSizeMediumRectangle
    self.bannerView.delegate = self;
    self.bannerView.adUnitID = @UNIT_ID;
    self.bannerView.rootViewController = self;
    self.bannerView.translatesAutoresizingMaskIntoConstraints = YES;
    self.bannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
}

```

### Interstitial implementation

Before start loading Admob you should load Bidmachine ad and save it to store

```objc
@import BidMachine;
@import BidMachineApiCore;
@import BidMachineAdMobAdapter;

- (void)before {
    __weak typeof(self) weakSelf = self;
    [BidMachineSdk.shared interstitial:nil :^(BidMachineInterstitial *ad, NSError *error) {
        [BidMachineAdMobAdapter store:ad];
        [weakSelf after];
    }];
}

- (void)after {
    GADRequest *request = [GADRequest request];
    [GADInterstitialAd loadWithAdUnitID:@UNIT_ID request:request completionHandler:^(GADInterstitialAd * _Nullable interstitialAd, NSError * _Nullable error) {
        if (error) {
            // fail load
        } else {
            self.interstitial = interstitialAd;
            self.interstitial.fullScreenContentDelegate = self;
        }
    }];
}

```

### Rewarded implementation

Before start loading Admob you should load Bidmachine ad and save it to store

```objc
@import BidMachine;
@import BidMachineApiCore;
@import BidMachineAdMobAdapter;

- (void)before {
   __weak typeof(self) weakSelf = self;
    [BidMachineSdk.shared rewarded:nil :^(BidMachineRewarded *ad, NSError *error) {
        [BidMachineAdMobAdapter store:ad];
        [weakSelf after];
    }];
}

- (void)after {
    GADRequest *request = [GADRequest request];
    [GADRewardedAd loadWithAdUnitID:@UNIT_ID request:request completionHandler:^(GADRewardedAd * _Nullable rewardedAd, NSError * _Nullable error) {
        if (error) {
            // fail load
        } else {
            self.rewarded = rewardedAd;
            self.rewarded.fullScreenContentDelegate = self;
        }
    }];
}
```

### Native ad implementation

Before start loading Admob you should load Bidmachine ad and save it to store

```objc
@import BidMachine;
@import BidMachineApiCore;
@import BidMachineAdMobAdapter;

- (void)before {
    [BidMachineSdk.shared native:nil :^(BidMachineNative *ad, NSError *error) {
        [BidMachineAdMobAdapter store:ad];
        [weakSelf after];
    }];
}

- (void)after {
    GADRequest *request = [GADRequest request];
    [self.nativeLoader loadRequest:request];
}

- (GADAdLoader *)nativeLoader {
    if (!_nativeLoader) {
        _nativeLoader = [[GADAdLoader alloc] initWithAdUnitID:@UNIT_ID
                                           rootViewController:self
                                                      adTypes:@[kGADAdLoaderAdTypeNative]
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

```
