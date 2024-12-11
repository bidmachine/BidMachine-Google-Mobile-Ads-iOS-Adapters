//
//  PublisherUnitIDsProvider.swift
//  BidMachineSampleSwift
//
//  Created by Dzmitry on 10/12/2024.
//

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
