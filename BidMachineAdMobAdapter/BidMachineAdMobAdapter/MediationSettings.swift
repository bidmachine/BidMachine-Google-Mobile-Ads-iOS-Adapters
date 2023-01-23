//
//  MediationSettings.swift
//  BidMachineAdMobAdapter
//
//  Created by Ilia Lozhkin on 21.12.2022.
//

import Foundation
import BidMachineApiCore

struct MediationSettings: Decodable {
    
    enum CompareType: String, Decodable {
        
        case equal  = "equal_pf"
        
        case equalOrBelow  = "equal_or_below_pf"
        
        case equalOrAbove  = "equal_or_above_pf"
    }
    
    private enum Keys: String, CodingKey {
        
        case bm_pf
        
        case bm_pf_compare
    }
    
    let price: Double
    
    let compareType: CompareType
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        guard let price = try? container.decode(String.self, forKey: .bm_pf) else {
            throw ErrorProvider.admob.withDescription("bm_pf params is nill")
        }
        
        guard let price = Double(price) else {
            throw ErrorProvider.admob.withDescription("bm_pf params should be Double as String")
        }
        
        self.price = price
        self.compareType = (try? container.decodeIfPresent(CompareType.self, forKey: .bm_pf_compare)) ?? .equalOrAbove
    }
}
