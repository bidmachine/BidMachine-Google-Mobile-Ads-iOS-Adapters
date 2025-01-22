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
  pod 'BidMachineAdMobAdapter', '~> 3.1.1.2'
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
    __weak typeof(self) weakSelf = self;
    id<BidMachineRequestConfigurationProtocol> config = [BidMachineSdk.shared requestConfiguration:BidMachinePlacementFormatBanner320x50 error:nil];
    [BidMachineSdk.shared banner:config :^(BidMachineBanner *ad, NSError *error) {
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
    let configuration = try BidMachineSdk.shared.requestConfiguration(.banner320x50)
    BidMachineSdk.shared.banner(configuration) { [weak self] banner, error in
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
    __weak typeof(self) weakSelf = self;
    [BidMachineSdk.shared interstitial:nil :^(BidMachineInterstitial *ad, NSError *error) {
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
    let configuration = try BidMachineSdk.shared.requestConfiguration(.interstitial)
    BidMachineSdk.shared.interstitial(configuration) { [weak self] interstitial, error in
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
   __weak typeof(self) weakSelf = self;
    [BidMachineSdk.shared rewarded:nil :^(BidMachineRewarded *ad, NSError *error) {
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
    let configuration = try BidMachineSdk.shared.requestConfiguration(.rewardedVideo)
    BidMachineSdk.shared.rewarded(configuration) { [weak self] rewarded, error in
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
    [BidMachineSdk.shared native:nil :^(BidMachineNative *ad, NSError *error) {
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
    let configuration = try BidMachineSdk.shared.requestConfiguration(.native)
    BidMachineSdk.shared.native(configuration) { [weak self] native, error in
        AdMobAdapter.store(native)
        self?.after()
    }
}

func after() {
    // Follow the approach outlined in the [Google Mobile Ads Native Ads Guide](https://developers.google.com/admob/ios/native) to load google Admob native ad
}
```
