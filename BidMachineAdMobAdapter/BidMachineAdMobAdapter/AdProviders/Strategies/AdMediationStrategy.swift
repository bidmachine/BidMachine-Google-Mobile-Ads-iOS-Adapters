//
//  AdLoadingStrategy.swift
//  BidMachineAdMobAdapter
//
//  Created by Dzmitry on 03/12/2024.
//

import Foundation
import BidMachine

protocol AdMediationStrategy {
    associatedtype Ad: BidMachineAdProtocol
    
    typealias SuccessCompetion = (Ad) -> Void
    typealias FailureCompetion = (Error) -> Void
    
    init(
        success: @escaping SuccessCompetion,
        failure: @escaping FailureCompetion
    )
    
    func load(
        configuration: BidMachineRequestConfigurationProtocol,
        settings: MediationSettings,
        format: PlacementFormat
    )

    func notifyLoadingError(_ error: Error)
}
