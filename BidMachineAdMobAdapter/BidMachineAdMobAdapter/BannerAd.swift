//
//  BannerAd.swift
//  BidMachineAdMobAdapter
//
//  Created by Ilia Lozhkin on 20.12.2022.
//

import Foundation
import BidMachine
import GoogleMobileAds


@objc class BannerAd: NSObject, MediationBannerAd {
    
    var view: UIView {
        return self.ad
    }
    
    weak var delegate: MediationBannerAdEventDelegate?
    
    private let ad: BidMachineBanner
    
    init(_ ad: BidMachineBanner) {
        self.ad = ad
        super.init()
        self.ad.delegate = self
        self.ad.controller = UIViewController.stk_topPresented
    }
}

extension BannerAd: BidMachineAdDelegate {
    
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
