//
//  BidMachineCustomEventAdapter.h
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 13.04.2022.
//  Copyright © 2022 Ilia Lozhkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface BidMachineCustomEventAdapter : NSObject <GADMediationAdapter>

@end

@interface BidMachineCustomEventBanner : BidMachineCustomEventAdapter

@end

@interface BidMachineCustomEventInterstitial : BidMachineCustomEventAdapter

@end

@interface BidMachineCustomEventRewarded : BidMachineCustomEventAdapter

@end

@interface BidMachineCustomEventNativeAd : BidMachineCustomEventAdapter

@end



NS_ASSUME_NONNULL_END
