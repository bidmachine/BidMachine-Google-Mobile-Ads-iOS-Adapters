//
//  BidMachineMediationUnifiedNativeAd.m
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 13.04.2022.
//  Copyright © 2022 Ilia Lozhkin. All rights reserved.
//

#import "BidMachineMediationUnifiedNativeAd.h"

@import StackFoundation;

@interface BidMachineNativeAdRendering : NSObject <BDMNativeAdRendering>

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *callToActionLabel;
@property (nonatomic, weak) UILabel *descriptionLabel;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UIView *mediaContainerView;
@property (nonatomic, weak) UIView *adChoiceView;

+ (instancetype)nativeAdRenderingWith:(NSDictionary<GADNativeAssetIdentifier, UIView *> *)assetViews;

@end

@implementation BidMachineMediationUnifiedNativeAd

- (BDMNativeAd *)nativeAd {
    if (!_nativeAd) {
        _nativeAd = BDMNativeAd.new;
    }
    return _nativeAd;
}

#pragma mark - GADMediatedUnifiedNativeAd

- (NSString *)headline {
    return self.nativeAd.title;
}

- (NSArray<GADNativeAdImage *> *)images {
    NSURL *imageUrl = [NSURL stk_url:self.nativeAd.mainImageUrl];
    if (imageUrl) {
        return ANY([[GADNativeAdImage alloc] initWithURL:imageUrl scale:1.0]).array;
    }
    return nil;
}

- (NSString *)body {
    return self.nativeAd.body;
}

- (GADNativeAdImage *)icon {
    NSURL *iconUrl = [NSURL stk_url:self.nativeAd.iconUrl];
    if (iconUrl) {
        return [[GADNativeAdImage alloc] initWithURL:iconUrl scale:1.0];
    }
    return nil;
}

- (NSString *)callToAction {
    return self.nativeAd.CTAText;
}

- (NSDecimalNumber *)starRating {
    if (self.nativeAd.starRating) {
        return [[NSDecimalNumber alloc] initWithInt:self.nativeAd.starRating.intValue];
    }
    return nil;
}

- (NSString *)store {
    return nil;
}

- (NSString *)price {
    return nil;
}

- (NSString *)advertiser {
    return nil;
}

- (NSDictionary<NSString *,id> *)extraAssets {
    return nil;
}

- (BOOL)hasVideoContent {
    return self.nativeAd.containsVideo;
}

- (void)didRenderInView:(UIView *)view
    clickableAssetViews:(NSDictionary<GADNativeAssetIdentifier,UIView *> *)clickableAssetViews
 nonclickableAssetViews:(NSDictionary<GADNativeAssetIdentifier,UIView *> *)nonclickableAssetViews
         viewController:(UIViewController *)viewController
{
    NSMutableDictionary<GADNativeAssetIdentifier, UIView *> *assetViews = NSMutableDictionary.new;
    [assetViews addEntriesFromDictionary:clickableAssetViews];
    [assetViews addEntriesFromDictionary:nonclickableAssetViews];
    
    BidMachineNativeAdRendering *adRendering = [BidMachineNativeAdRendering nativeAdRenderingWith:assetViews];
    
    self.nativeAd.rootViewController = viewController;
    [self.nativeAd presentOn:view
              clickableViews:clickableAssetViews.allValues
                 adRendering:adRendering
                       error:nil];
}

- (void)didUntrackView:(UIView *)view {
    [self.nativeAd unregisterViews];
}

@end

@implementation BidMachineNativeAdRendering

+ (instancetype)nativeAdRenderingWith:(NSDictionary<GADNativeAssetIdentifier, UIView *> *)assetViews
{
    return [[self alloc] initWithAssetViews:assetViews];
}

- (instancetype)initWithAssetViews:(NSDictionary<GADNativeAssetIdentifier, UIView *> *)assetViews {
    if (self = [super init]) {
        _titleLabel = (UILabel *)assetViews[GADNativeHeadlineAsset];
        _callToActionLabel = (UILabel *)assetViews[GADNativeCallToActionAsset];
        _descriptionLabel = (UILabel *)assetViews[GADNativeBodyAsset];
        _iconView = (UIImageView *)assetViews[GADNativeIconAsset];
        _mediaContainerView = assetViews[GADNativeMediaViewAsset];
        _adChoiceView = assetViews[GADNativeAdChoicesViewAsset];
    }
    return self;
}

@end
