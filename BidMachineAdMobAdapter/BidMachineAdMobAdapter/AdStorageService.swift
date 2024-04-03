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
    
    private var items = Synchronized([AdStorageItem]())
}

extension AdStorageService {
    
    typealias StoreResult = (prebid: Bool, ad: BidMachineAdProtocol?)
    
    func store(_ ad: BidMachineAdProtocol) {
        let item = AdStorageItem(ad)
        items.write { $0.append(item) }
        item.prepare(self)
    }
    
    func fetchResult(_ format: PlacementFormat,
                     _ settings: MediationSettings) -> StoreResult {
        
        guard let placementType = format.placementType() else {
            return (false, nil)
        }
        
        let placement = Placement(placementType)
        let items = self.items.read({ $0.filter { $0.placement == placement } })
        
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
        items.write({ $0.removeAll { $0.id == item.id } })
    }
}

extension AdStorageService: AdStorageItemDelegate {
    
    func didExpired(_ item: AdStorageItem) {
        _remove(item)
    }
}
