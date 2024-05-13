//
//  InterstitialAd.swift
//  BidMachineAdMobAdapter
//
//  Created by Ilia Lozhkin on 20.12.2022.
//

import Foundation
import BidMachine
import GoogleMobileAds


@objc class InterstitialAd: NSObject, GADMediationInterstitialAd {
    
    weak var delegate: GADMediationInterstitialAdEventDelegate?
    
    private let ad: BidMachineInterstitial
    
    init(_ ad: BidMachineInterstitial) {
        self.ad = ad
    }
    
    func present(from viewController: UIViewController) {
        self.ad.controller = viewController
        self.ad.delegate = self
        self.ad.presentAd()
    }
}

extension InterstitialAd: BidMachineAdDelegate {
    
    func didLoadAd(_ ad: BidMachineAdProtocol) {
        // NO-OP
    }
    
    func didFailLoadAd(_ ad: BidMachineAdProtocol, _ error: Error) {
        // NO-OP
    }
    
    func didPresentAd(_ ad: BidMachineAdProtocol) {
        self.delegate?.willPresentFullScreenView()
    }
    
    func didFailPresentAd(_ ad: BidMachineAdProtocol, _ error: Error) {
        self.delegate?.didFailToPresentWithError(error)
    }
    
    func didDismissAd(_ ad: BidMachineAdProtocol) {
        self.delegate?.willDismissFullScreenView()
        self.delegate?.didDismissFullScreenView()
    }
    
    func willPresentScreen(_ ad: BidMachineAdProtocol) {
        // NO-OP
    }
    
    func didDismissScreen(_ ad: BidMachineAdProtocol) {
        // NO-OP
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

