//
//  BidMachineAdProvider.swift
//  BidMachineAdMobAdapter
//
//  Created by Ilia Lozhkin on 20.12.2022.
//

import Foundation
import BidMachine
import GoogleMobileAds
import BidMachineApiCore

class BidMachineAdProvider <T: BidMachineAdProtocol>: BidMachineAdDelegate {
    
    typealias AdSuccessCompetion = (T) -> Void
    
    typealias AdFailureCompetion = (Error) -> Void
    
    private var success: AdSuccessCompetion?
    
    private var failure: AdFailureCompetion?
    
    private var ad: T?
    
    private var format: PlacementFormat
    
    init(_ format: PlacementFormat) {
        self.format = format
    }
    
    func loadAd(mediationParams: GADMediationCredentials,
                success: @escaping AdSuccessCompetion,
                failure: @escaping AdFailureCompetion)
    {
        let settings: MediationSettings
        let configuration: BidMachineRequestConfigurationProtocol
        do {
            settings = try mediationParams.mediationSettings()
            configuration = try BidMachineSdk.shared.requestConfiguration(self.format)
        } catch {
            failure(error)
            return
        }
        
        configuration.populate {
            $0.appendPriceFloor(settings.price.xRound(), "bm_pf:\(settings.price.xRound())")
        }
        
        self.success = success
        self.failure = failure
        
        let storageResult = AdMobAdapter.shared.storageService.fetchResult(format, settings)
        if storageResult.prebid {
            _makePrebid(storageResult.ad, configuration)
        } else {
            _makeWaterfall(configuration)
        }
    }
    
    func didLoadAd(_ ad: BidMachineAdProtocol) {
        ad.delegate = nil
        guard let ad = ad as? T else {
            failure?(ErrorProvider.admob.withDescription("Ad loaded with unknown placement"))
            return
        }
        
        success?(ad)
    }
    
    func didFailLoadAd(_ ad: BidMachineAdProtocol, _ error: Error) {
        ad.delegate = nil
        failure?(error)
    }
}

extension BidMachineAdProvider {
    
    func _makeWaterfall(_ configuration: BidMachineRequestConfigurationProtocol) {
        BidMachineSdk.shared.ad(T.self, configuration) { [weak self] ad, error in
            guard let self = self else {
                return
            }
            
            if let error = error {
                self.failure?(error)
            } else if let ad = ad {
                self.ad = ad
                ad.delegate = self
                ad.loadAd()
            } else {
                self.failure?(ErrorProvider.admob.withDescription("Ad can't be nill"))
            }
        }
    }
    
    func _makePrebid(_ ad: BidMachineAdProtocol?, _ configuration: BidMachineRequestConfigurationProtocol) {
        guard let ad = ad else {
            self.failure?(ErrorProvider.admob.withDescription("Can't find prebid ad with current price \(configuration.priceFloors)"))
            return
        }
        
        ad.delegate = self
        ad.loadAd()
    }
}
