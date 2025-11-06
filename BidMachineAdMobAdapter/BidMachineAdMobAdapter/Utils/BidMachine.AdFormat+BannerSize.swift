//  
//  BidMachineAdMobAdapter
//
//  Created by BidMachine Team on 03/11/2025.
//  Copyright © 2025 BidMachine Inc. All rights reserved.

import Foundation
import BidMachine
import GoogleMobileAds

extension BidMachine.AdFormat {
    static func bannerFromGoogleSize(_ size: GoogleMobileAds.AdSize) -> BidMachine.AdFormat? {
        let closestSize = closestValidSizeForAdSizes(
            original: size,
            possibleAdSizes: [
                nsValue(for: AdSizeBanner),
                nsValue(for: AdSizeLeaderboard),
                nsValue(for: AdSizeMediumRectangle)
            ]
        )
        
        if isAdSizeEqualToSize(size1: closestSize, size2: AdSizeBanner) {
            return .banner320x50
        } else if isAdSizeEqualToSize(size1: closestSize, size2: AdSizeLeaderboard) {
            return .banner728x90
        } else if isAdSizeEqualToSize(size1: closestSize, size2: AdSizeMediumRectangle) {
            return .banner300x250
        } else if size.size.height == 0, let width = UInt32(exactly: size.size.width) {
            return .bannerAdaptive(width: width)
        } else {
            return nil
        }
    }
}
