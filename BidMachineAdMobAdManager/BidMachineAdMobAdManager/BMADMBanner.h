//
//  BMADMBanner.h
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 5/18/20.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import <BidMachineAdMobAdManager/BMADMAdEventProtocol.h>


@interface BMADMBanner : NSObject <BMADMAdEventProtocol>

@property (nonatomic, weak) id<BMADMAdEventDelegate> delegate;

- (void)hide;

@end
