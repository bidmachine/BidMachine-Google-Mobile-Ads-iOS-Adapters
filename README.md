![BidMachine iOS](https://appodeal-ios.s3-us-west-1.amazonaws.com/docs/bidmachine.png)

# BidMachine IOS AdMob HeaderBidding Sample

- [Getting Started](#user-content-getting-started)
- [Initialize sdk](#user-content-initialize-sdk)
- [Banner implementation](#user-content-banner-implementation)
- [MREC implementation](#user-content-mrec-implementation)
- [Interstitial implementation](#user-content-interstitial-implementation)
- [Rewarded implementation](#user-content-rewarded-implementation)
- [Native ad implementation](#user-content-native-ad-implementation)
- [Changelog](#user-content-changelog)

## Getting Started

##### Add following lines into your project Podfile

```ruby
target 'Target' do
  project 'Project.xcodeproj'
  pod 'GoogleMobileAds-BidMachine-Adapters', '~> 1.9.4.0'
end
```

> **_NOTE:_** If you want to use BidMachine Header Bidding, please, also add following lines

```ruby
target 'Target' do
  project 'Project.xcodeproj'
  pod 'GoogleMobileAds-BidMachine-Adapters', '~> 1.9.4.0'
  pod "BDMAdColonyAdapter", "~> 1.9.4.0"
  pod "BDMAmazonAdapter", "~> 1.9.4.0"
  pod "BDMCriteoAdapter", "~> 1.9.4.0"
  pod "BDMFacebookAdapter", "~> 1.9.4.0"
  pod "BDMMyTargetAdapter", "~> 1.9.4.0"
  pod "BDMSmaatoAdapter", "~> 1.9.4.0"
  pod "BDMTapjoyAdapter", "~> 1.9.4.0"
  pod "BDMVungleAdapter", "~> 1.9.4.0"
  pod "BDMPangleAdapter", "~> 1.9.4.0"
end
```

### Initialize sdk

> **_WARNING:_** Before initialize AdMob sdk you should start BM sdk. 
>  All parameters for BM sdk must be set before starting.

> **_NOTE:_** **storeURL** and **storeId** - are required parameters

``` objc
    BDMSdkConfiguration *config = [BDMSdkConfiguration new];
    config.testMode = YES;

    config.targeting = BDMTargeting.new;
    config.targeting.storeURL = [NSURL URLWithString:@"https://storeUrl"];
    config.targeting.storeId = @"12345";

    [BDMSdk.sharedSdk startSessionWithSellerID:@"5"
                                 configuration:config
                                    completion:nil];
```

##### Yours implementation of initialization should look like this:

```objc
    BDMSdkConfiguration *config = [BDMSdkConfiguration new];
    config.testMode = YES;

    config.targeting = BDMTargeting.new;
    config.targeting.storeURL = [NSURL URLWithString:@"https://storeUrl"];
    config.targeting.storeId = @"12345";

    [BDMSdk.sharedSdk startSessionWithSellerID:@"5"
                                 configuration:config
                                    completion:^{

        [[GADMobileAds sharedInstance] startWithCompletionHandler:^(GADInitializationStatus * _Nonnull status) {
            NSDictionary *statuses = status.adapterStatusesByClassName;
            NSLog(@"%@", [statuses.allKeys componentsJoinedByString:@","]);
        }];
    }];
```

##### In the example below, the way to set all parameters

> **_NOTE:_** **storeId** and **storeURL** are required. The other parameters are optional.

```objc

    BDMSdkConfiguration *config = [BDMSdkConfiguration new];

    config.baseURL = [NSURL URLWithString:@"https://baseURL"];
    config.testMode = YES;
    config.targeting = BDMTargeting.new;
    config.targeting.userId = @"userId";
    config.targeting.gender = kBDMUserGenderFemale;
    config.targeting.yearOfBirth = @(1990);
    config.targeting.keywords = @"keywords";
    config.targeting.blockedCategories = @[@"bcat1", @"bcat2"];
    config.targeting.blockedAdvertisers = @[@"badv1", @"badv2"];
    config.targeting.blockedApps = @[@"bapp1", @"bapp2"];
    config.targeting.country = @"country";
    config.targeting.city = @"city";
    config.targeting.zip = @"zip";
    config.targeting.storeURL =  [NSURL URLWithString:@"https://storeUrl"];
    config.targeting.storeId = @"12345";
    config.targeting.paid = YES;
    config.targeting.storeCategory = @"storeCat";
    config.targeting.storeSubcategory = @[@"subcat1", @"subcat2"];
    config.targeting.frameworkName = BDMNativeFramework;
    config.targeting.deviceLocation = [[CLLocation alloc] initWithLatitude:1 longitude:2];
    
    BDMSdk.sharedSdk.publisherInfo = [BDMPublisherInfo new];
    BDMSdk.sharedSdk.publisherInfo.publisherId = @"pubId";
    BDMSdk.sharedSdk.publisherInfo.publisherName = @"pubName";
    BDMSdk.sharedSdk.publisherInfo.publisherDomain = @"pubdomain";
    BDMSdk.sharedSdk.publisherInfo.publisherCategories = @[@"pubcat1", @"pubcat2"];
    
    BDMSdk.sharedSdk.restrictions.coppa = YES;
    BDMSdk.sharedSdk.restrictions.subjectToGDPR = YES;
    BDMSdk.sharedSdk.restrictions.hasConsent = YES;
    BDMSdk.sharedSdk.restrictions.consentString = @"consentString";
    BDMSdk.sharedSdk.restrictions.USPrivacyString = @"usPrivacy";
    
    BDMSdk.sharedSdk.enableLogging = YES;
    [BDMSdk.sharedSdk startSessionWithSellerID:@"5"
                                 configuration:config
                                    completion:nil];
```

##### If you are using Header Bidding networks, then you need to set their parameters as follows

All network required fields and values types are described in BidMachine doc. ([WIKI](https://wiki.appodeal.com/display/BID/BidMachine+iOS+SDK+Documentation#BidMachineiOSSDKDocumentation-AdNetworksConfigurationsParameters)). If ad network has initialisation parameters, it should be added in root of mediation config object. Ad network ad unit specific paramters should be added in root of ad unit object.

```objc

    BDMSdkConfiguration *config = [BDMSdkConfiguration new];

    config.targeting = BDMTargeting.new;
    config.targeting.storeURL = [NSURL URLWithString:@"https://storeUrl"];
    config.targeting.storeId = @"12345";

    config.networkConfigurations = @[[BDMAdNetworkConfiguration buildWithBuilder:^(BDMAdNetworkConfigurationBuilder *builder) {
        builder.appendName(@"criteo");
        builder.appendNetworkClass(NSClassFromString(@"BDMCriteoAdNetwork"));
        builder.appendParams(@{@"publisher_id": @"XXX"});
        builder.appendAdUnit(BDMAdUnitFormatBanner320x50, @{ @"ad_unit_id": @"XXX" }, nil);
    }]];

    [BDMSdk.sharedSdk startSessionWithSellerID:@"5"
                                 configuration:config
                                    completion:nil];
```

### Banner implementation

First you need to create a request and execute it

```objc

    self.request = [BDMBannerRequest new];
    self.request.adSize = BDMBannerAdSize320x50;
    [self.request performWithDelegate:self];

```

After polling the request, you need to save the request for bid (**[BDMRequestStorage.shared saveRequest:request];**)

```objc

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BidMachineFetcher will capture request by itself
    self.request = nil;
    // Save request for bid
    [BDMRequestStorage.shared saveRequest:request];
    // Here we define which Admob ad should be loaded
    [self makeRequest];
}

```

Then you can create an admob object and load it

```objc

- (void)makeRequest {

    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    self.bannerView.delegate = self;
    self.bannerView.adUnitID = @UNIT_ID;
    self.bannerView.rootViewController = self;
    self.bannerView.translatesAutoresizingMaskIntoConstraints = YES;
    self.bannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
}

```

### MREC implementation

First you need to create a request and execute it

```objc

    self.request = [BDMBannerRequest new];
    self.request.adSize = BDMBannerAdSize300x250;
    [self.request performWithDelegate:self];

```

After polling the request, you need to save the request for bid (**[BDMRequestStorage.shared saveRequest:request];**)

```objc

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BidMachineFetcher will capture request by itself
    self.request = nil;
    // Save request for bid
    [BDMRequestStorage.shared saveRequest:request];
    // Here we define which Admob ad should be loaded
    [self makeRequest];
}

```

Then you can create an admob object and load it

```objc

- (void)makeRequest {
  
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeMediumRectangle];
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

First you need to create a request and execute it

```objc

    self.request = [BDMInterstitialRequest new];
    [self.request performWithDelegate:self];

```

After polling the request, you need to save the request for bid (**[BDMRequestStorage.shared saveRequest:request];**)

```objc

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BidMachineFetcher will capture request by itself
    self.request = nil;
    // Save request for bid
    [BDMRequestStorage.shared saveRequest:request];
    // Here we define which Admob ad should be loaded
    [self makeRequest];
}

```

Then you can create an admob object and load it

```objc

- (void)makeRequest {
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

First you need to create a request and execute it

```objc
    self.request = [BDMRewardedRequest new];
    [self.request performWithDelegate:self];

```

After polling the request, you need to save the request for bid (**[BDMRequestStorage.shared saveRequest:request];**)

```objc

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BidMachineFetcher will capture request by itself
    self.request = nil;
    // Save request for bid
    [BDMRequestStorage.shared saveRequest:request];
    // Here we define which Admob ad should be loaded
    [self makeRequest];
}

```

Then you can create an admob object and load it

```objc

- (void)makeRequest {
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

First you need to create a request and execute it

```objc

    self.request = [BDMNativeAdRequest new];
    [self.request performWithDelegate:self];

```

After polling the request, you need to save the request for bid (**[BDMRequestStorage.shared saveRequest:request];**)

```objc

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    // After request complete loading application can lost strong ref on it
    // BidMachineFetcher will capture request by itself
    self.request = nil;
    // Save request for bid
    [BDMRequestStorage.shared saveRequest:request];
    // Here we define which Admob ad should be loaded
    [self makeRequest];
}

```

Then you can create an admob object and load it

```objc

- (void)makeRequest {
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


##  Changelog

### Version 1.9.4.0

* Update BidMachine to 1.9.4.0 +
* Update 'Google-Mobile-Ads-SDK' to '9.8.0'

### Version 1.9.2.0

* Update BidMachine to 1.9.2.1
* Update 'Google-Mobile-Ads-SDK' to '9.3.0'

### Version 1.8.0.0

* Update BidMachine to 1.8.0.0

### Version 1.7.4.0

* Update BidMachine to 1.7.4.0
* Update 'Google-Mobile-Ads-SDK' to '8.12.0'

### Version 1.7.3.0

* Update BidMachine to 1.7.3.0

### Version 1.7.1.0

* Update BidMachine to 1.7.1.0

### Version 1.6.5.0

* Update BidMachine to 1.6.5

### Version 1.6.4.0

* Update BidMachine to 1.6.4
* Update 'Google-Mobile-Ads-SDK' to '8.2.0.1'

### Version 1.5.2.0

* Update BidMachine to 1.5.2

### Version 1.5.0.1

* Update 'Google-Mobile-Ads-SDK' to '7.62.0'

### Version 1.5.0.0

* Update BidMachine to 1.5.0

### Version 1.4.2.0

* Update BidMachine to 1.4.2

### Version 1.4.1.0

* Update BidMachine to 1.4.1

### Version 1.4.0.0

* Update BidMachine to 1.4.0
* Add Native Ad support

### Version 1.3.0.0

* Update BidMachine to 1.3.0
* Add Header Bidding Supports
