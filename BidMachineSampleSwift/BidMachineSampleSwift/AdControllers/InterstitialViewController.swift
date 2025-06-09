//
//  Copyright © 2024 Appodeal. All rights reserved.
//

import UIKit
import GoogleMobileAds
import BidMachineAdMobAdapter
import BidMachine

final class InterstitialViewController: AdLoadController {
    private var interstitial: InterstitialAd?

    override var topTitle: String? {
        "Interstitial"
    }

    override func loadAd() {
        deleteLoadedAd()
        switchState(to: .loading)
        
        let placement = try? BidMachineSdk.shared.placement(from: .interstitial)
        guard let placement else {
            showAlert(with: "Unsupported placement")
            switchState(to: .idle)
            return
        }
        
        let request = BidMachineSdk.shared.auctionRequest(placement: placement)

        BidMachineSdk.shared.interstitial(request: request) { [weak self] interstitial, error in
            guard let self else {
                return
            }
            guard let interstitial else {
                self.switchState(to: .idle)
                self.showAlert(with: "Error occurred: \(error?.localizedDescription ?? "")")
                return
            }
            AdMobAdapter.store(interstitial)
            self.makeRequest()
        }
    }
 
    override func showAd() {
        switchState(to: .idle)

        guard let interstitial else {
            showAlert(with: "No inter to show")
            return
        }
        interstitial.present(from: self)
    }

    private func makeRequest() {
        let request = Request()

        InterstitialAd.load(
            with: Environment.current.interstitialUnitID,
            request: request
        ) { [weak self] interstitial, error in
            guard let self else {
                return
            }
            guard let interstitial else {
                self.switchState(to: .idle)
                self.showAlert(with: "Error occurred: \(error?.localizedDescription ?? "")")
                return
            }
            self.switchState(to: .loaded)
            self.interstitial = interstitial
            interstitial.fullScreenContentDelegate = self
        }
    }

    private func deleteLoadedAd() {
        interstitial = nil
    }
}

extension InterstitialViewController: FullScreenContentDelegate {
    func adDidRecordImpression(_ ad: any FullScreenPresentingAd) {
        print("[DEBUG]: adDidRecordImpression")
    }
    
    func adDidRecordClick(_ ad: any FullScreenPresentingAd) {
        print("[DEBUG]: adDidRecordClick")
    }
    
    func ad(_ ad: any FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: any Error) {
        print("[DEBUG]: didFailToPresentFullScreenContentWithError \(error.localizedDescription)")
    }
    
    func adWillPresentFullScreenContent(_ ad: any FullScreenPresentingAd) {
        print("[DEBUG]: adWillPresentFullScreenContent")
    }
    
    func adWillDismissFullScreenContent(_ ad: any FullScreenPresentingAd) {
        print("[DEBUG]: adWillDismissFullScreenContent")
    }
    
    func adDidDismissFullScreenContent(_ ad: any FullScreenPresentingAd) {
        print("[DEBUG]: adDidDismissFullScreenContent")
    }
}
