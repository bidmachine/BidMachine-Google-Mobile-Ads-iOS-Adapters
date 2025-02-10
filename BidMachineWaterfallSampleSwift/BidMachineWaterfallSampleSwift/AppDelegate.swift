//
//  Copyright © 2024 Appodeal. All rights reserved.
//

import UIKit
import BidMachine
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let scene = application.connectedScenes.first as? UIWindowScene else {
            return false
        }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = AppModule.create(for: AdType.allCases)
        window?.makeKeyAndVisible()
        
        setupBidMachine()
        startAdMob()

        return true
    }
    
    private func setupBidMachine() {
        BidMachineSdk.shared.populate { builder in
            builder.withTestMode(true)
            builder.withLoggingMode(true)
            builder.withBidLoggingMode(true)
            builder.withEventLoggingMode(true)
        }
    }
    
    private func startAdMob() {
        MobileAds.shared.start { status in
            let notReadyAdapters = status
                .adapterStatusesByClassName
                .filter { $0.value.state == .notReady }

            print((["[⚠️ WARNING]: Not ready for use adapters"] + notReadyAdapters.keys).joined(separator: "\n"))
        }
    }
}
