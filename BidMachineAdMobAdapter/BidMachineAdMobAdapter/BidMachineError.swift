//
//  BidMachineError.swift
//  BidMachineAdMobAdapter
//
//  Created by Ilia Lozhkin on 20.12.2022.
//

import Foundation
import BidMachineApiCore

extension ErrorProvider {
    
    static var admob: BidMachineErrorValueBuilder {
        return ErrorProvider.unknown("BM Admob Adapter").badContent
    }
    
}
