//
//  WaterfallMediationAdapter.swift
//  BidMachineAdMobAdapter
//
//  Created by Dzmitry on 04/12/2024.
//

import Foundation
import BidMachine
import GoogleMobileAds

class WaterfallMediationAdapter: MediationAdapter {
    static func setUpWith(
        _ configuration: GADMediationServerConfiguration,
        completionHandler: @escaping GADMediationAdapterSetUpCompletionBlock
    ) {
        let completion: () -> Void
        defer { completion() }
        
        guard RuntimeInitializationStorage.shared.initialization == nil else {
            completion = { completionHandler(nil) }
            return
        }
        do {
            let initialization = try InitializationGuard.initialization(
                with: configuration.credentials.first
            )
            BidMachineSdk.shared.initializeSdk(initialization.sourceID)
            RuntimeInitializationStorage.shared.initialization = initialization

            completion = { completionHandler(nil) }

        } catch let error {
            completion = { completionHandler(error) }
        }
    }
}

private extension WaterfallMediationAdapter {
    final class RuntimeInitializationStorage {
        var initialization: Initialization?
        
        private init() {}
        
        static let shared = RuntimeInitializationStorage()
    }
}

private extension WaterfallMediationAdapter {
    struct Initialization {
        let sourceID: String
    }

    struct InitializationGuard {
        static func initialization(with credential: GADMediationCredentials?) throws -> Initialization {
            guard let credential else {
                throw ErrorProvider.admob.withDescription("Missing vital credentials for waterfall SDK initialization")
            }
            guard !BidMachineSdk.shared.isInitialized else {
                throw ErrorProvider.admob.withDescription("SDK initialized manually. Its forbidden for waterfall integration")
            }
            guard let sourceID = try credential.mediationSettings().sourceID else {
                throw ErrorProvider.admob.withDescription("Missing SDK initialization key in server configuration credentials")
            }
            
            return Initialization(sourceID: sourceID)
        }
    }
}
