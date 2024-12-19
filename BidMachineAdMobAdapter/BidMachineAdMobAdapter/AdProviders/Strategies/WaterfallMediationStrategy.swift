//
//  WaterfallAdRequestStrategy.swift
//  BidMachineAdMobAdapter
//
//  Created by Dzmitry on 03/12/2024.
//

import Foundation
import BidMachine

final class WaterfallMediationStrategy<T: BidMachineAdProtocol>: NSObject, AdMediationStrategy, BidMachineAdDelegate {
    typealias Ad = T

    private let success: SuccessCompetion
    private let failure: FailureCompetion
    
    enum LoadingError: Error {
        case unknownState
    }
    
    private var ad: Ad?
    
    init(
        success: @escaping SuccessCompetion,
        failure: @escaping FailureCompetion
    ) {
        self.success = success
        self.failure = failure
    }
    
    func load(
        configuration: BidMachineRequestConfigurationProtocol,
        settings: MediationSettings,
        format: PlacementFormat
    ) {
        BidMachineSdk.shared.ad(T.self, configuration) { [weak self] ad, error in
            guard let self else { return }

            if let error {
                handleLoadingError(description: "Error occured: \(error.localizedDescription)")
                return
            }
            if let ad {
                handleLoadingSuccess(ad)
                return
            }
            handleLoadingError(description: "Unknown state: no error, no ad")
        }
    }

    func notifyLoadingError(_ error: Error) {
        self.failure(error)
    }
    
    private func handleLoadingError(description: String) {
        failure(ErrorProvider.admob.withDescription(description))
    }
    
    private func handleLoadingSuccess(_ ad: T) {
        self.ad = ad
        ad.delegate = self
        ad.loadAd()
    }
    
    func didFailLoadAd(_ ad: BidMachineAdProtocol, _ error: any Error) {
        ad.delegate = nil
        self.ad = nil

        failure(error)
    }
    
    func didLoadAd(_ ad: BidMachineAdProtocol) {
        self.ad = nil
        ad.delegate = nil

        guard let ad = ad as? T else {
            notifyLoadingError(ErrorProvider.admob.withDescription("Ad loaded with unknown placement"))
            return
        }
        success(ad)
    }
}
