//
//  BidMachineWaterfallSampleSwift
//
//  Created by BidMachine Team on 10/01/2025.
//  Copyright © 2025 BidMachine Inc. All rights reserved.

import Foundation

protocol UnitIDProvider {
    var isReady: Bool { get }

    var banner: String { get }
    var interstitial: String { get }
    var rewarded: String { get }
    var native: String { get }
}

struct Environment {
    private let provider: UnitIDProvider
    
    static var current = Environment(
        provider: PublisherUnitIDsProvider()
    )

    private init(provider: UnitIDProvider) {
        guard provider.isReady else {
            fatalError(
                """
                The Unit ID provider is not set up. 
                Please populate PublisherUnitIDsProvider with at least one valid unit ID,
                or use GoogleTestUnitIDsProvider in the current environment initialization,
                pre-filled with Google’s predefined unit ID values.
                """
            )
        }
        self.provider = provider
    }

    var bannerUnitID: String {
        provider.banner
    }
    
    var interstitialUnitID: String {
        provider.interstitial
    }
    
    var rewardedUnitID: String {
        provider.rewarded
    }
    
    var nativeUnitID: String {
        provider.native
    }
}
