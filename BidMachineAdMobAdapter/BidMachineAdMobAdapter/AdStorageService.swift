//
//  AdStorageService.swift
//  BidMachineAdMobAdapter
//
//  Created by Ilia Lozhkin on 21.12.2022.
//

import Foundation
import BidMachine
import BidMachineApiCore

class AdStorageService {
    
    @Atomic private var items = [AdStorageItem]()
}

extension AdStorageService {
    
    typealias StoreResult = (prebid: Bool, ad: BidMachineAdProtocol?)
    
    func store(_ ad: BidMachineAdProtocol) {
        let item = AdStorageItem(ad)
        items.append(item)
        item.prepare(self)
    }
    
    func fetchResult(_ format: PlacementFormat,
                     _ settings: MediationSettings) -> StoreResult {
        
        guard let placementType = format.placementType() else {
            return (false, nil)
        }
        
        let placement = Placement(placementType)
        let items = self.items.filter { $0.placement == placement }
        
        if items.count == 0 {
            return (false, nil)
        }
        
        let item = items
            .filter { $0.compare(settings.price, settings.compareType) }
            .sorted { $0.price.xRound() > $1.price.xRound() }
            .first
        
        guard let item = item else {
            return (true, nil)
        }
        
        _remove(item)
        return (true, item.ad)
    }
}
 
private extension AdStorageService {
    
    func _remove(_ item: AdStorageItem) {
        items.removeAll { $0.id == item.id }
    }
}

extension AdStorageService: AdStorageItemDelegate {
    
    func didExpired(_ item: AdStorageItem) {
        _remove(item)
    }
}
