//
//  PrebidAdRequestStrategy.swift
//  BidMachineAdMobAdapter
//
//  Created by Dzmitry on 03/12/2024.
//

import Foundation
import BidMachine

final class PrebidMediationStrategy<T: BidMachineAdProtocol>: NSObject, AdMediationStrategy, BidMachineAdDelegate {
    typealias Ad = T
    
    private let success: SuccessCompetion
    private let failure: FailureCompetion
    
    private var ad: Ad?
    
    init(
        success: @escaping SuccessCompetion,
        failure: @escaping FailureCompetion
    ) {
        self.success = success
        self.failure = failure
    }
    
    func load(settings: MediationSettings, format: BidMachine.AdFormat) {
        let storageResult = AdMobAdapter.shared.storageService.fetchResult(format, settings)
        
        guard storageResult.prebid else  {
            failure(ErrorProvider.admob.withDescription("Can't find prebid ad"))
            return
        }
        guard let storageAd = storageResult.ad else {
            let price = NumberFormatter.bidMachinePrice.string(
                from: NSNumber(value: settings.price)
            )!
            let description = "Can't find prebid ad with current price \(price)"
            failure(
                ErrorProvider.admob.withDescription(description)
            )
            return
        }
        guard let casted = storageAd as? Ad else {
            failure(ErrorProvider.admob.withDescription("Ad fetched with unknown placement"))
            return
        }
        _makePrebid(casted)
    }
    
    func notifyLoadingError(_ error: Error) {
        self.failure(error)
    }

    private func _makePrebid(_ ad: Ad) {
        self.ad = ad
        
        ad.delegate = self
        ad.loadAd()
    }

    func didFailLoadAd(_ ad: any BidMachine.BidMachineAdProtocol, _ error: any Error) {
        ad.delegate = nil
        self.ad = nil
        failure(error)
    }
    
    func didLoadAd(_ ad: BidMachineAdProtocol) {
        self.ad = nil
        ad.delegate = nil

        guard let ad = ad as? T else {
            failure(ErrorProvider.admob.withDescription("Ad loaded with unknown placement"))
            return
        }
        success(ad)
    }
}
