//
//  BMADMFetcher.m
//  BidMachineAdMobAdManager
//
//  Created by Ilia Lozhkin on 5/18/20.
//  Copyright © 2020 Appodeal. All rights reserved.
//

#import "BMADMFetcher.h"

@interface BMADMFetcher ()

@property (nonatomic, strong) NSNumberFormatter *formatter;

@end

@implementation BMADMFetcher

+ (instancetype)shared {
    static BMADMFetcher *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = BMADMFetcher.new;
    });
    return _instance;
}

- (NSNumberFormatter *)formatter {
    if (!_formatter) {
        _formatter = [NSNumberFormatter new];
        _formatter.numberStyle = NSNumberFormatterDecimalStyle;
        _formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        _formatter.roundingMode = NSNumberFormatterRoundCeiling;
        _formatter.positiveFormat = @"0.00";
    }
    return _formatter;
}

- (void)setRoundingMode:(NSNumberFormatterRoundingMode)roundingMode {
    self.formatter.roundingMode = roundingMode;
}

- (NSNumberFormatterRoundingMode)roundingMode {
    return self.formatter.roundingMode;
}

- (void)setFormat:(NSString *)format {
    self.formatter.positiveFormat = format;
}

- (NSString *)format {
    return self.formatter.positiveFormat;
}

- (NSDictionary<NSString *,id> *)fetchParamsFromRequest:(BDMRequest *)request {
    if (!request.info.bidID) {
        return nil;
    }
    
    NSMutableDictionary *params =  [request.info extrasWithCustomParams:@{@"bm_platform" : @"ios"}].mutableCopy;
    params[@"bm_pf"] = [self.formatter stringFromNumber:request.info.price];
    return params;
}

@end
