//
//  BMADMInterstitial.h
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 5/15/20.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import <BidMachineAdMobAdManager/BMADMAdEventProtocol.h>


@interface BMADMInterstitial : NSObject <BMADMAdEventProtocol>

@property (nonatomic, weak) id<BMADMAdEventDelegate> delegate;

@end
