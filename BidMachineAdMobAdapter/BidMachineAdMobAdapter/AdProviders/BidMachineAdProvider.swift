//
//  BidMachineAdProvider.swift
//  BidMachineAdMobAdapter
//
//  Created by Dzmitry on 03/12/2024.
//

import Foundation
import BidMachine
import GoogleMobileAds

final class BidMachineAdProvider<T: BidMachineAdProtocol> {
    private let format: PlacementFormat
    private let strategy: any AdMediationStrategy
    
    init(
        format: PlacementFormat,
        strategy: any AdMediationStrategy
    ) {
        self.format = format
        self.strategy = strategy
    }
    
    func loadAd(mediationParams: MediationCredentials) {
        let settings: MediationSettings

        do {
            settings = try mediationParams.mediationSettings()
        } catch {
            strategy.notifyLoadingError(error)
            return
        }

        strategy.load(settings: settings, format: format)
    }
}

extension NumberFormatter {
    static let bidMachinePrice = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.roundingMode = .ceiling
        formatter.positiveFormat = "0.00"

        return formatter
    }()
}
