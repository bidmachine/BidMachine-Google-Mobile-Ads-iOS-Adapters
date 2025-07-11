//  
//  BidMachineAdMobAdapter
//
//  Created by BidMachine Team on 11/07/2025.
//  Copyright © 2025 BidMachine Inc. All rights reserved.

import os

enum AppLogger {
    static func error(_ message: String, category: String) {
        os_log(
            "%{public}@",
            log: .init(
                subsystem: Bundle.main.bundleIdentifier ?? "com.bidmachine.admob_adapter",
                category: category
            ),
            type: .error,
            message
        )
    }
}
