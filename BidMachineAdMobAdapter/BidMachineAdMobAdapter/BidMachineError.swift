//
//  BidMachineError.swift
//  BidMachineAdMobAdapter
//
//  Created by Ilia Lozhkin on 20.12.2022.
//

import Foundation
import BidMachine


extension ErrorProvider {
    
    static var admob: BidMachineErrorValueBuilder {
        return ErrorProvider.unknown("BM Admob Adapter").badContent
    }
    
}
