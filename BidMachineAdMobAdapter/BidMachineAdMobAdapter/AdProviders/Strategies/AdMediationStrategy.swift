//
//  AdLoadingStrategy.swift
//  BidMachineAdMobAdapter
//
//  Created by Dzmitry on 03/12/2024.
//

import Foundation
import BidMachine

// AdMediationStrategy must inherit from NSObject to ensure compatibility with the Objective-C runtime.
// This is necessary because in current implementation it conforms to the @objc protocol BidMachineAdDelegate.
// Removing NSObject inheritance will cause crashes when a Swift object conforms to an @objc protocol.

protocol AdMediationStrategy: NSObject {
    associatedtype Ad: BidMachineAdProtocol
    
    typealias SuccessCompetion = (Ad) -> Void
    typealias FailureCompetion = (Error) -> Void
    
    init(success: @escaping SuccessCompetion, failure: @escaping FailureCompetion)
    func load(settings: MediationSettings, format: PlacementFormat)
    func notifyLoadingError(_ error: Error)
}
