//
//  NativeAd.swift
//  BidMachineAdMobAdapter
//
//  Created by Ilia Lozhkin on 20.12.2022.
//

import Foundation
import BidMachine
import GoogleMobileAds
import BidMachineApiCore

@objc class NativeAd: NSObject, GADMediationNativeAd {
    
    weak var delegate: GADMediationNativeAdEventDelegate?
    
    private let ad: BidMachineNative
    
    init(_ ad: BidMachineNative) {
        self.ad = ad
        super.init()
        self.ad.delegate = self
    }
}

extension NativeAd {
    
    var headline: String? { ad.title }
    
    var body: String? { ad.body }
    
    var callToAction: String? { ad.cta }
    
    var starRating: NSDecimalNumber? { nil }
    
    var store: String? { nil }
    
    var price: String? { nil }
    
    var advertiser: String? { nil }
    
    var extraAssets: [String : Any]? { nil }
    
    var hasVideoContent: Bool { ad.isVideo }
    
    var icon: GADNativeAdImage? {
        ad.icon
        .flatMap { URL(string: $0) }
        .flatMap { GADNativeAdImage(url: $0, scale: 1.0) }
    }
    
    var images: [GADNativeAdImage]? {
        ad.main
        .flatMap { URL(string: $0) }
        .flatMap { GADNativeAdImage(url: $0, scale: 1.0) }
        .flatMap { [$0] }
    }
}

extension NativeAd {
    
    func handlesUserClicks() -> Bool {
        return true
    }
    
    func handlesUserImpressions() -> Bool {
        return true
    }
    
    func didRender(in view: UIView,
                   clickableAssetViews: [GADNativeAssetIdentifier : UIView],
                   nonclickableAssetViews: [GADNativeAssetIdentifier : UIView],
                   viewController: UIViewController)
    {
        var assets = clickableAssetViews
        assets.merge(nonclickableAssetViews){ (_, new) in new }
        
        let rendering = NativeAdRendering(assets)
        
        self.ad.controller = viewController
        
        do {
            try self.ad.presentAd(view, rendering)
        } catch  {
            self.delegate?.didFailToPresentWithError(error)
        }
       
    }
}

extension NativeAd: BidMachineAdDelegate {
    
    func didLoadAd(_ ad: BidMachineAdProtocol) {
        // NO-OP
    }
    
    func didFailLoadAd(_ ad: BidMachineAdProtocol, _ error: Error) {
        // NO-OP
    }
    
    func didPresentAd(_ ad: BidMachineAdProtocol) {
        // NO-OP
    }
    
    func didFailPresentAd(_ ad: BidMachineAdProtocol, _ error: Error) {
        self.delegate?.didFailToPresentWithError(error)
    }
    
    func didDismissAd(_ ad: BidMachineAdProtocol) {
        // NO-OP
    }
    
    func willPresentScreen(_ ad: BidMachineAdProtocol) {
        self.delegate?.willPresentFullScreenView()
    }
    
    func didDismissScreen(_ ad: BidMachineAdProtocol) {
        self.delegate?.willDismissFullScreenView()
        self.delegate?.didDismissFullScreenView()
    }
    
    func didUserInteraction(_ ad: BidMachineAdProtocol) {
        self.delegate?.reportClick()
    }
    
    func didExpired(_ ad: BidMachineAdProtocol) {
        // NO-OP
    }
    
    func didTrackImpression(_ ad: BidMachineAdProtocol) {
        self.delegate?.reportImpression()
    }
    
    func didTrackInteraction(_ ad: BidMachineAdProtocol) {
        // NO-OP
    }
}
