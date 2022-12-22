//
//  BidMachineAdMobAdapter.swift
//  BidMachineAdMobAdapter
//
//  Created by Ilia Lozhkin on 21.12.2022.
//

import Foundation
import BidMachine

@objc (BidMachineAdMobAdapter) public class BidMachineAdMobAdapter: NSObject {
    
    static let shared: BidMachineAdMobAdapter = BidMachineAdMobAdapter()
    
    let storageService = AdStorageService()
    
    private override init() {
        
    }
}


@objc public extension BidMachineAdMobAdapter {
    
    static func store(_ ad: BidMachineAdProtocol?) {
        Self.shared._store(ad)
    }
}

private extension BidMachineAdMobAdapter {
    
    func _store(_ ad: BidMachineAdProtocol?) {
        guard let ad = ad else {
            return
        }

        storageService.store(ad)
    }
    
}
