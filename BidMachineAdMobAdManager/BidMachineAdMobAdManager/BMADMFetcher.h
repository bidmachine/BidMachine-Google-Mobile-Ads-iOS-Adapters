//
//  BMADMFetcher.h
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 5/18/20.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BidMachine/BidMachine.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMADMFetcher : NSObject

@property (nonatomic, assign) NSNumberFormatterRoundingMode roundingMode;
@property (nonatomic, copy) NSString *format;

+ (instancetype)shared;

- (nullable NSDictionary <NSString *, id> *)fetchParamsFromRequest:(BDMRequest *)request;

@end

NS_ASSUME_NONNULL_END
