//
//  NativeAdRenderer.h
//  AdMobBidMachineSample
//
//  Created by Ilia Lozhkin on 11/28/19.
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface NativeAdRenderer : NSObject

+ (void)renderAd:(GADNativeAd *)ad onView:(UIView *)view;

+ (void)unregister:(GADNativeAd *)ad fromView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
