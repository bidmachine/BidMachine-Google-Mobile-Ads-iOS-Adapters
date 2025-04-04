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
        configuration.populate {
            $0.withCustomParameters([CustomParamsKey.mediationMode: "waterfall_admob"])
        }
        BidMachineSdk.shared.ad(Ad.self, configuration) { [weak self] ad, error in
            guard let self else { return }

            if let error {
                handleLoadingError(description: "Error occured: \(error.localizedDescription)")
                return
            }
            if let ad {
                handleAdLoaded(ad, for: configuration)
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
    
    private func handleAdLoaded(_ ad: Ad, for configuration: BidMachineRequestConfigurationProtocol) {
        guard let minPriceFloor = configuration.priceFloors.min(by: { $0.price < $1.price }) else {
            handleLoadingSuccess(ad)
            return
        }
        guard ad.auctionInfo.price >= minPriceFloor.price else {
            handleLoadingError(description: "Loaded ad doesn't meet price floor requirements")
            return
        }
        handleLoadingSuccess(ad)
    }
    
    private func handleLoadingSuccess(_ ad: Ad) {
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

        guard let ad = ad as? Ad else {
            notifyLoadingError(ErrorProvider.admob.withDescription("Ad loaded with unknown placement"))
            return
        }
        success(ad)
    }
}
