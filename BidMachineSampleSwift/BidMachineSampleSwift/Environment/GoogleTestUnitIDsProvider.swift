//
//  GoogleTestUnitIDsProvider.swift
//  BidMachineSampleSwift
//
//  Created by Dzmitry on 10/12/2024.
//

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
