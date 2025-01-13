//  
//  BidMachineSampleSwift
//
//  Created by BidMachine Team on 10/01/2025.
//  Copyright © 2025 BidMachine Inc. All rights reserved.

import Foundation

struct GoogleTestUnitIDsProvider: UnitIDProvider {
    var isReady: Bool {
        true
    }

    let banner = "ca-app-pub-3940256099942544/2435281174"
    let interstitial = "ca-app-pub-3940256099942544/4411468910"
    let rewarded = "ca-app-pub-3940256099942544/1712485313"
    let native = "ca-app-pub-3940256099942544/3986624511"
}

