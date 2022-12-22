//
//  BidMachineExtension.swift
//  BidMachineAdMobAdapter
//
//  Created by Ilia Lozhkin on 20.12.2022.
//

import Foundation
import BidMachine
import GoogleMobileAds
import BidMachineApiKit

fileprivate struct Constants {
    
    static let parameters = "parameter"
    
    static let price = "bm_pf"
    
}

extension GADMediationCredentials {
    
    func mediationSettings() throws -> MediationSettings {
        return try json.decode(MediationSettings.self)
    }
    
    var json: [String : Any] {
        let parameters = self.settings[Constants.parameters] as? String
        let json = try? parameters?.JSON()
        return json ?? [:]
    }
}

extension GADVersionNumber {
    
    static func version(_ ver: String) -> GADVersionNumber {
        let separatedVersion = ver.components(separatedBy: ".").compactMap { Int($0) }
        
        var majorVersion: Int = 0
        var minorVersion: Int = 0
        var patchVersion: Int = 0
        
        if separatedVersion.count >= 3 {
            majorVersion = separatedVersion[0]
            minorVersion = separatedVersion[1]
            patchVersion = separatedVersion[2]
            
            if separatedVersion.count == 4 {
                let path = separatedVersion[2]
                let bug = separatedVersion[3]
                
                if bug / 100 > 0 {
                    patchVersion = (path * 1000) + bug
                } else if bug / 10 > 0 {
                    patchVersion = (path * 100) + bug
                } else {
                    patchVersion = (path * 10) + bug
                }
            }
        }
        
        return GADVersionNumber(majorVersion: majorVersion,
                                minorVersion: minorVersion,
                                patchVersion: patchVersion)
    }
}

extension CGSize {
    
    var format: PlacementFormat {
        switch self.height {
        case 50: return .banner320x50
        case 90: return .banner728x90
        case 250: return .banner300x250
        default: return .banner
        }
    }
}

extension Double {
    
    func xRound() -> Double {
        return self
//        return (self * 100).rounded() / 100
    }
    
}

extension AdStorageItem {
    
    func compare(_ price: Double, _ type: MediationSettings.CompareType) -> Bool {
        switch type {
        case .equal: return price.xRound() == self.price.xRound()
        case .equalOrBelow: return price.xRound() >= self.price.xRound()
        case .equalOrAbove: return price.xRound() <= self.price.xRound()
        }
    }
    
}
