//
//  BidMachineAdMobAdapter.swift
//  BidMachineAdMobAdapter
//
//  Created by Ilia Lozhkin on 21.12.2022.
//

import Foundation
import BidMachine

@objc(BDMAdMobAdapter) public class AdMobAdapter: NSObject {
    
    static let shared: AdMobAdapter = AdMobAdapter()
    
    let storageService = AdStorageService()
    
    private override init() {
        
    }
}


@objc public extension AdMobAdapter {
    
    static func store(_ ad: BidMachineAdProtocol?) {
        Self.shared._store(ad)
    }
}

private extension AdMobAdapter {
    
    func _store(_ ad: BidMachineAdProtocol?) {
        guard let ad = ad else {
            return
        }

        storageService.store(ad)
    }
    
}
