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

```ruby
target 'Target' do
  project 'Project.xcodeproj'
  pod 'BidMachineAdMobAdapter', '~> 3.3.0.0'
end
```

### Initialize sdk

The BidMachineAdMobAdapter starting 3.1.1.2 version offers robust support for both prebid and waterfall integration.
Both integration types require to configure mediations group in AdMob account by adding BidMachine Custom Events and Mappings.

#### Waterfall:
Waterfall integration does not require BidMachineSdk initialization code, as it is triggered automatically as part of the GADMobileAds initialization.
However, if you need to configure additional BidMachineSdk settings, refer to the [documentation](https://docs.bidmachine.io/docs/in-house-mediation-ios)

#### Prebid:
> **_WARNING:_** Before initialize AdMob sdk you should start BM sdk. 

Objective-C:
```objc
#import <GoogleMobileAds/GoogleMobileAds.h>

@import BidMachine;
@import BidMachineAdMobAdapter;

[BidMachineSdk.shared populate:^(id<BidMachineInfoBuilderProtocol> builder) {
    [builder withTestMode:YES];
    [builder withLoggingMode:YES];
    [builder withBidLoggingMode:YES];
    [builder withEventLoggingMode:YES];
}];
    
[BidMachineSdk.shared initializeSdk: @"YOUR_SOURCE_ID"];

[[GADMobileAds sharedInstance] startWithCompletionHandler:^(GADInitializationStatus * _Nonnull status) {
    NSDictionary *statuses = status.adapterStatusesByClassName;
    NSLog(@"%@", [statuses.allKeys componentsJoinedByString:@","]);
}];
```

Swift:
```swift
import BidMachine
import BidMachineAdMobAdapter
import GoogleMobileAds

BidMachineSdk.shared.populate { builder in
    builder
        .withTestMode(true)
        .withLoggingMode(true)
        .withBidLoggingMode(true)
        .withEventLoggingMode(true)
}
BidMachineSdk.shared.initializeSdk("YOUR_SOURCE_ID")

GADMobileAds.sharedInstance().start { status in
    let statuses = status.adapterStatusesByClassName
    print(statuses.keys.joined(separator: ","))
}
```

### Banner implementation

#### Waterfall:
Integration remains consistent with the approach outlined in [Google Mobile Ads Banner Ads Guide](hhttps://developers.google.com/admob/ios/banner), ensuring seamless compatibility with existing configurations.
No further modifications are necessary, streamlining the implementation process and minimizing any additional overhead.

#### Prebid:
Before start loading Admob you should load Bidmachine ad and save it to store

> **_NOTE:_** For some banners you should use some placment (BidMachinePlacementFormatBanner320x50, BidMachinePlacementFormatBanner300x250)

Objective-C:
```objc
@import BidMachine;
@import BidMachineAdMobAdapter;

- (void)before {
    NSError *error = nil;
    BidMachinePlacement *placement = [[BidMachineSdk shared] placementFrom:BidMachinePlacementFormatBanner320x50 error:&error builder:nil];
    if (!placement) {
        return;
    }

    BidMachineAuctionRequest *request = [[BidMachineSdk shared] auctionRequestWithPlacement:placement builder:nil];
    
    __weak typeof(self) weakSelf = self;
    [BidMachineSdk.shared bannerWithRequest:request completion:^(BidMachineBanner *ad, NSError *error) {
        [BidMachineAdMobAdapter store:ad]; 
        [weakSelf after];
    }];
}

- (void)after {
    // Follow the approach outlined in the [Google Mobile Ads Banner Ads Guide](https://developers.google.com/admob/ios/banner) to load google Admob banner ad
}
```

Swift:
```swift
import BidMachine
import BidMachineAdMobAdapter

func before() throws {
    let placement = try? BidMachineSdk.shared.placement(from: .banner320x50)
    guard let placement else { return }
    let request = BidMachineSdk.shared.auctionRequest(placement: placement)

    BidMachineSdk.shared.banner(request: request) { [weak self] banner, error in
        AdMobAdapter.store(banner)
        self?.after()
    }
}

func after() {
    // Follow the approach outlined in the [Google Mobile Ads Banner Ads Guide](https://developers.google.com/admob/ios/banner) to load google Admob banner ad
}
```

### Interstitial implementation

#### Waterfall:
Integration remains consistent with the approach outlined in [Google Mobile Ads Interstitial Ads Guide](https://developers.google.com/admob/ios/interstitial), ensuring seamless compatibility with existing configurations. 
No further modifications are necessary, streamlining the implementation process and minimizing any additional overhead.

#### Prebid:
Before start loading Admob you should load Bidmachine ad and save it to store

Objective-C:
```objc
@import BidMachine;
@import BidMachineApiCore;
@import BidMachineAdMobAdapter;

- (void)before {
    NSError *error = nil;
    BidMachinePlacement *placement = [[BidMachineSdk shared] placementFrom:BidMachinePlacementFormatInterstitial error:&error builder:nil];
    if (!placement) {
        return;
    }

    BidMachineAuctionRequest *request = [[BidMachineSdk shared] auctionRequestWithPlacement:placement builder:nil];
    
    __weak typeof(self) weakSelf = self;
    [BidMachineSdk.shared interstitialWithRequest:request completion:^(BidMachineInterstitial *ad, NSError *error) {
        [BidMachineAdMobAdapter store:ad];
        [weakSelf after];
    }];
}

- (void)after {
    // Follow the approach outlined in the [Google Mobile Ads Interstitial Ads Guide](https://developers.google.com/admob/ios/interstitial) to load google Admob interstitial ad
}
```

Swift:
```swift
import BidMachine
import BidMachineAdMobAdapter

func before() throws {
    let placement = try? BidMachineSdk.shared.placement(from: .interstitial)
    guard let placement else { return }
    let request = BidMachineSdk.shared.auctionRequest(placement: placement)

    BidMachineSdk.shared.interstitial(request: request) { [weak self] interstitial, error in
        AdMobAdapter.store(interstitial)
        self?.after()
    }
}

func after() {
    // Follow the approach outlined in the [Google Mobile Ads Interstitial Ads Guide](https://developers.google.com/admob/ios/interstitial) to load google Admob interstitial ad
}
```

### Rewarded implementation

#### Waterfall:
Integration remains consistent with the approach outlined in [Google Mobile Ads Rewarded Ads Guide](https://developers.google.com/admob/ios/rewarded), ensuring seamless compatibility with existing configurations. 
No further modifications are necessary, streamlining the implementation process and minimizing any additional overhead.

#### Prebid:
Before start loading Admob you should load Bidmachine ad and save it to store

Objective-C:
```objc
@import BidMachine;
@import BidMachineAdMobAdapter;

- (void)before {
    NSError *error = nil;
    BidMachinePlacement *placement = [[BidMachineSdk shared] placementFrom:BidMachinePlacementFormatRewarded error:&error builder:nil];
    if (!placement) {
        return;
    }

    BidMachineAuctionRequest *request = [[BidMachineSdk shared] auctionRequestWithPlacement:placement builder:nil];
    
    __weak typeof(self) weakSelf = self;
    [BidMachineSdk.shared rewardedWithRequest:request completion:^(BidMachineRewarded *ad, NSError *error) {
        [BidMachineAdMobAdapter store:ad];
        [weakSelf after];
    }];
}

- (void)after {
    // Follow the approach outlined in the [Google Mobile Ads Rewarded Ads Guide](https://developers.google.com/admob/ios/rewarded) to load google Admob rewarded ad
}
```

Swift:
```swift
import BidMachine
import BidMachineAdMobAdapter

func before() throws {
    let placement = try? BidMachineSdk.shared.placement(from: .rewardedVideo)
    guard let placement else { return }
    
    let request = BidMachineSdk.shared.auctionRequest(placement: placement)

    BidMachineSdk.shared.rewarded(request: request) { [weak self] rewarded, error in
        AdMobAdapter.store(rewarded)
        self?.after()
    }
}

func after() {
    // Follow the approach outlined in the [Google Mobile Ads Rewarded Ads Guide](https://developers.google.com/admob/ios/rewarded) to load google Admob rewarded ad
}
```

### Native ad implementation

#### Waterfall:
Integration remains consistent with the approach outlined in [Google Mobile Ads Native Ads Guide](https://developers.google.com/admob/ios/native), ensuring seamless compatibility with existing configurations. 
No further modifications are necessary, streamlining the implementation process and minimizing any additional overhead.

#### Prebid:
Before start loading Admob you should load Bidmachine ad and save it to store

Objective-C:
```objc
@import BidMachine;
@import BidMachineAdMobAdapter;

- (void)before {
    NSError *error = nil;
    BidMachinePlacement *placement = [[BidMachineSdk shared] placementFrom:BidMachinePlacementFormatNative error:&error builder:nil];
    if (!placement) {
        return;
    }

    BidMachineAuctionRequest *request = [[BidMachineSdk shared] auctionRequestWithPlacement:placement builder:nil];
    
    __weak typeof(self) weakSelf = self;
    [BidMachineSdk.shared nativeWithRequest:request completion:^(BidMachineNative *ad, NSError *error) {
        [BidMachineAdMobAdapter store:ad];
        [weakSelf after];
    }];
}

- (void)after {
    // Follow the approach outlined in the [Google Mobile Ads Native Ads Guide](https://developers.google.com/admob/ios/native) to load google Admob native ad
}
```

Swift:
```swift
import BidMachine
import BidMachineAdMobAdapter

func before() throws {
    let placement = try? BidMachineSdk.shared.placement(from: .native)
    guard let placement else { return }
    
    let request = BidMachineSdk.shared.auctionRequest(placement: placement)

    BidMachineSdk.shared.native(request: request) { [weak self] nativeAd, error in
        AdMobAdapter.store(native)
        self?.after()
    }
}

func after() {
    // Follow the approach outlined in the [Google Mobile Ads Native Ads Guide](https://developers.google.com/admob/ios/native) to load google Admob native ad
}
```
