//
//  MediationSettings.swift
//  BidMachineAdMobAdapter
//
//  Created by Ilia Lozhkin on 21.12.2022.
//

import Foundation
import BidMachine


struct MediationSettings: Decodable {
    
    enum CompareType: String, Decodable {
        
        case equal  = "equal_pf"
        
        case equalOrBelow  = "equal_or_below_pf"
        
        case equalOrAbove  = "equal_or_above_pf"
    }
    
    private enum Keys: String, CodingKey {
        
        case bm_pf
        
        case bm_pf_compare
        
        case source_id
        
        case placement_id
    }
    
    let price: Double
    
    let compareType: CompareType
    
    let sourceID: String?
    
    let placementID: String?
    
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
        self.sourceID = try? container.decodeIfPresent(String.self, forKey: .source_id)

        guard let placement = try? container.decodeIfPresent(String.self, forKey: .placement_id) else {
            self.placementID = nil
            return
        }
        if placement.isEmpty {
            self.placementID = nil
            AppLogger.error("placement_id should not be an empty string", category: "mediation_settings")
        } else {
            self.placementID = placement
        }
    }
}
