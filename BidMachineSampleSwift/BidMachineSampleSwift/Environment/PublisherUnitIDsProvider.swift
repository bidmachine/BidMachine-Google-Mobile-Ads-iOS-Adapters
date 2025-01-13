//  
//  BidMachineSampleSwift
//
//  Created by BidMachine Team on 10/01/2025.
//  Copyright © 2025 BidMachine Inc. All rights reserved.

import Foundation

struct PublisherUnitIDsProvider: UnitIDProvider {
    var isReady: Bool {
        [banner, interstitial, rewarded, native].contains(where: { !$0.isEmpty })
    }

    let banner = ""
    let interstitial = ""
    let rewarded = ""
    let native = ""
}
