//
//  Copyright © 2024 Appodeal. All rights reserved.
//

import UIKit
import GoogleMobileAds
import BidMachineAdMobAdapter
import BidMachine

private enum Constant {
    static let unitID = "ca-app-pub-3216013768320747/4019430704" // "your unit id here"
}

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
            if let error {
                self.switchState(to: .idle)
                self.showAlert(with: error.localizedDescription)
            } else {
                AdMobAdapter.store(interstitial)
                self.makeRequest()
            }
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
            withAdUnitID: Constant.unitID,
            request: request
        ) { [weak self] interstitial, error in
            guard let self else {
                return
            }
            if let error {
                self.switchState(to: .idle)
                self.showAlert(with: "Error: \(error.localizedDescription)")
            } else {
                self.switchState(to: .loaded)
                self.interstitial = interstitial
                self.interstitial?.fullScreenContentDelegate = self
            }
        }
    }

    private func deleteLoadedAd() {
        interstitial = nil
    }
}

extension InterstitialViewController: GADFullScreenContentDelegate {
    func adDidRecordImpression(_ ad: any GADFullScreenPresentingAd) {

    }
    
    func adDidRecordClick(_ ad: any GADFullScreenPresentingAd) {

    }
    
    func ad(_ ad: any GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: any Error) {

    }
    
    func adWillPresentFullScreenContent(_ ad: any GADFullScreenPresentingAd) {

    }
    
    func adWillDismissFullScreenContent(_ ad: any GADFullScreenPresentingAd) {

    }
    
    func adDidDismissFullScreenContent(_ ad: any GADFullScreenPresentingAd) {

    }
}
