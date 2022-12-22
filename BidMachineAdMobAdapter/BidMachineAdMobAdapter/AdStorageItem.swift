//
//  AdStorageItem.swift
//  BidMachineAdMobAdapter
//
//  Created by Ilia Lozhkin on 21.12.2022.
//

import Foundation
import BidMachine
import StackFoundation
import BidMachineApiKit

protocol AdStorageItemDelegate: AnyObject {
    
    func didExpired(_ item: AdStorageItem)
}

class AdStorageItem {
    
    let id: String = UUID().uuidString
    
    private weak var delegate: AdStorageItemDelegate?
    
    private let _ad: BidMachineAdProtocol
    
    init(_ ad: BidMachineAdProtocol) {
        _ad = ad
    }
}

extension AdStorageItem {
    
    var price: Double {
        return _ad.auctionInfo.price
    }
    
    var placement: Placement {
        return _ad.requestInfo.placement.placement
    }
    
    var ad: BidMachineAdProtocol {
        return _ad
    }
}

extension AdStorageItem {
    
    func prepare(_ delegate: AdStorageItemDelegate?) {
        _ad.controller = UIViewController.stk_topPresented
        _ad.delegate = self
        _ad.loadAd()
    }
}

extension AdStorageItem: BidMachineAdDelegate {
    
    func didLoadAd(_ ad: BidMachineAdProtocol) {
        // NO-OP
    }
    
    func didFailLoadAd(_ ad: BidMachineAdProtocol, _ error: Error) {
        self.delegate?.didExpired(self)
    }
    
    func didExpired(_ ad: BidMachineAdProtocol) {
        self.delegate?.didExpired(self)
    }
}
