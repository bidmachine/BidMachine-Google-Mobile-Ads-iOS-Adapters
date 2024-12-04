//
//  Copyright © 2024 Appodeal. All rights reserved.
//

import UIKit
import GoogleMobileAds
import BidMachineAdMobAdapter
import BidMachine

final class InterstitialViewController: AdLoadController {
    private var interstitial: GADInterstitialAd?

    override var topTitle: String? {
        "Interstitial"
    }

    override func loadAd() {
        deleteLoadedAd()
        switchState(to: .loading)
        
        BidMachineSdk.shared.interstitial { [weak self] interstitial, error in
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
        interstitial.present(fromRootViewController: self)
    }

    private func makeRequest() {
        let request = GADRequest()

        GADInterstitialAd.load(
            withAdUnitID: Constant.UnitID.Interstitial.googleTest,
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

extension InterstitialViewController: GADFullScreenContentDelegate {
    func adDidRecordImpression(_ ad: any GADFullScreenPresentingAd) {
        print("[DEBUG]: adDidRecordImpression")
    }
    
    func adDidRecordClick(_ ad: any GADFullScreenPresentingAd) {
        print("[DEBUG]: adDidRecordClick")
    }
    
    func ad(_ ad: any GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: any Error) {
        print("[DEBUG]: didFailToPresentFullScreenContentWithError \(error.localizedDescription)")
    }
    
    func adWillPresentFullScreenContent(_ ad: any GADFullScreenPresentingAd) {
        print("[DEBUG]: adWillPresentFullScreenContent")
    }
    
    func adWillDismissFullScreenContent(_ ad: any GADFullScreenPresentingAd) {
        print("[DEBUG]: adWillDismissFullScreenContent")
    }
    
    func adDidDismissFullScreenContent(_ ad: any GADFullScreenPresentingAd) {
        print("[DEBUG]: adDidDismissFullScreenContent")
    }
}
