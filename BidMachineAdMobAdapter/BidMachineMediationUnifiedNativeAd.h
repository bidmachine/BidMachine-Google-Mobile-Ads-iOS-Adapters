//
//  BidMachineMediationUnifiedNativeAd.h
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 13.04.2022.
//  Copyright © 2022 Ilia Lozhkin. All rights reserved.
//

#import "BidMachineMediationAdapter.h"

@interface BidMachineMediationUnifiedNativeAd : BidMachineMediationAdapter <GADMediatedUnifiedNativeAd>

@property (nonatomic, strong) BDMNativeAd *nativeAd;

@end
