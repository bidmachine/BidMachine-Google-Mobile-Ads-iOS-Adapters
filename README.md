# BidMachine adapter for AdMob

This folder contains mediation adapter used to mediate BidMachine.

## Getting Started

### Initialization parameters

To initialize BidMachine you can define your's seller id in GADCustomEventExtras of bannerView and interstitial (also you can define parameters like test mode and logging that are set during initialization and define all parameters that can be used to set the targeting):

```
GADRequest *request = [GADRequest request];
GADCustomEventExtras *extras = [GADCustomEventExtras new];
NSDictionary *localExtras = @{
            @"seller_id": @"2",
            @"coppa": @"true",
            @"logging_enabled": @"true",
            @"test_mode": @"true",
            @"userId": @"user123",
            @"gender": @"F",
            @"yob": @"2000",
            @"keywords": @"Keyword_1,Keyword_2,Keyword_3,Keyword_4",
            @"country": @"USA",
            @"city": @"Los Angeles",
            @"zip": @"90001–90084",
            @"sturl": @"https://store_url.com",
            @"paid": @"true",
            @"bcat": @"IAB-1,IAB-3,IAB-5",
            @"badv": @"https://domain_1.com,https://domain_2.org",
            @"bapps": @"com.test.application_1,com.test.application_2,com.test.application_3",
            @"priceFloors": @[@{
                                @"id_1": @300.06
                                }, @{
                                     @"id_2": @1000
                                    },
                                @302.006,
                                @1002
                                ]
            };
[extras setExtras:localExtras forLabel: @"BannerLable"];
[self.bannerView loadRequest:request];
```
Or you can set it from the AdMobUI in parameter string.

### Test mode

To setup test mode in BidMachine add to ***GADCustomEventExtras*** @"test_mode" : @"true". You ***GADCustomEventExtras*** will be similar to what is shown below:
```
GADCustomEventExtras *extras = [GADCustomEventExtras new];
NSDictionary *localExtras = @{ @"test_mode": @"true" };
[extras setExtras:localExtras forLabel: @"BannerLable"];
```
### Logging

To setup logging in BidMachine add @"logging_enabled" : @"true" flag to ***GADCustomEventExtras***:
```
GADCustomEventExtras *extras = [GADCustomEventExtras new];
NSDictionary *localExtras = @{ @"logging_enabled": @"true" };
[extras setExtras:localExtras forLabel: @"BannerLable"];
```
### Initialization

All parameters that are used during initialization are presented in table below:

| Parameter | Type |
| --- | --- |
| **Required** |
| seller_id | String |
| **Optional** |
| test_mode | String |
| logging_enabled | String|

### Transfer targeting data to BidMachine

If you want to transfer targeting information you can use custom event's property ***localExtras*** which represents dictionary.
Keys for ***localExtras*** are listed below (Banner and Interstitial):

```
@"user_id"   --> Vendor-specific ID for the user (NSString)
@"gender"   --> User gender refer to OpenRTB 2.5 spec (kBDMUserGenderMale, kBDMUserGenderFemale, kBDMUserGenderUnknown)
@"yob"      --> User year of birth (NSNumber)
@"keywords" --> Comma separated list of keywords about the app (NSString)
@"bcat"     --> Blocked advertiser categories using the IAB content categories. Refer to List 5.1 (NSArray <NSString *>)
@"badv"     --> Block list of advertisers by their domains (e.g., “ford.com”) (NSArray <NSString *>)
@"bapps"    --> Block list of applications by their platform-specific exchange- independent application identifiers (NSArray <NSString *>)
@"country"  --> User country (NSString)
@"city"     --> User city (NSString)
@"zip"      --> User zip code (NSString)
@"sturl"    --> Store URL (NSURL)
@"stid"     --> Numeric store id identifier (NSString)
@"paid"     --> Paid version of app (NSNumber: 0-free, 1-paid)
```
Also you can transfer user location via extras. You can ad two more keys:
```
@"lat" - User's latitude (NSDouble)
@"lon" - User's longitude (NSDouble)
```
### Banners implementation

In the snippet below you can see transfering of local extra data:

```
self.adView = [[MPAdView alloc] initWithAdUnitId:@"AD_UNIT_ID"
                                                size:MOPUB_BANNER_SIZE];
    self.adView.delegate = self;
    self.adView.frame = CGRectMake((self.view.bounds.size.width - MOPUB_BANNER_SIZE.width) / 2,
                                   self.view.bounds.size.height - MOPUB_BANNER_SIZE.height,
                                   MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    [self.view addSubview:self.adView];
    NSDictionary *localExtras = @{
                                  @"seller_id": @"YOUR_SELLER_ID",
                                  @"coppa": @"true",
                                  @"logging_enabled": @"true",
                                  @"test_mode": @"true",
                                  @"banner_width": @"320",
                                  @"userId": @"user123",
                                  @"gender": @"F",
                                  @"yob": @"2000",
                                  @"keywords": @"Keyword_1,Keyword_2,Keyword_3,Keyword_4",
                                  @"country": @"USA",
                                  @"city": @"Los Angeles",
                                  @"zip": @"90001–90084",
                                  @"sturl": @"https://store_url.com",
                                  @"paid": @"true",
                                  @"bcat": @"IAB-1,IAB-3,IAB-5",
                                  @"badv": @"https://domain_1.com,https://domain_2.org",
                                  @"bapps": @"com.test.application_1,com.test.application_2,com.test.application_3",
                                  @"priceFloors": @[@{
                                                        @"id_1": @300.06
                                                        }, @{
                                                        @"id_2": @1000
                                                        },
                                                    @302.006,
                                                    @1002
                                                    ]
                                  };
    [self.adView setLocalExtras:localExtras];
    [self.adView loadAd];
```

But also you can receive extra data from server. It will be sent in (NSDictionary *)***info*** of requests methods and may look like this:

```

```

### Interstitial implementation

With local extra data:

```
    
```

Servers extra data:

```

```

### Rewarded implementation

With local extra data:

```

```

Extra data from server:

```

```
