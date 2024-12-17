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
    
    func loadAd(mediationParams: GADMediationCredentials) {
        let settings: MediationSettings
        let configuration: BidMachineRequestConfigurationProtocol

        do {
            settings = try mediationParams.mediationSettings()
            configuration = try BidMachineSdk.shared.requestConfiguration(self.format)
        } catch {
            strategy.notifyLoadingError(error)
            return
        }
        let price = NumberFormatter.bidMachinePrice.string(
            from: NSNumber(value: settings.price)
        )!
        
        configuration.populate {
            $0.appendPriceFloor(settings.price, "bm_pf:\(price)")
        }
        strategy.load(configuration: configuration, settings: settings, format: format)
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
