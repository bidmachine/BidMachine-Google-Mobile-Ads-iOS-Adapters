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
        
        startBidMachine()
        startAdMob()

        return true
    }
    
    private func startBidMachine() {
        BidMachineSdk.shared.populate { builder in
            builder.withTestMode(true)
            builder.withLoggingMode(true)
            builder.withBidLoggingMode(true)
            builder.withEventLoggingMode(true)
        }
        BidMachineSdk.shared.initializeSdk("154")
    }
    
    private func startAdMob() {
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["0364fe200acbb0d9a468177494e7e27a"]
        
        GADMobileAds.sharedInstance().start { status in
            let statuses = status.adapterStatusesByClassName
            print(statuses.keys.joined(separator: ","))
        }
    }
}

