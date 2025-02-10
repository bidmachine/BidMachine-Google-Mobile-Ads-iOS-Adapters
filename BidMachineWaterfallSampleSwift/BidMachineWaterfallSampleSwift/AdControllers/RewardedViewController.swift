//
//  Copyright © 2024 Appodeal. All rights reserved.
//

import UIKit
import GoogleMobileAds
import BidMachineAdMobAdapter
import BidMachine

final class RewardedViewController: AdLoadController {
    private var rewarded: RewardedAd?
    
    override var topTitle: String? {
        "Rewarded"
    }

    override func loadAd() {
        deleteLoadedAd()
        switchState(to: .loading)
        makeRequest()
    }
    
    override func showAd() {
        switchState(to: .idle)
        
        guard let rewarded else {
            showAlert(with: "No rewarded to show")
            return
        }
        rewarded.present(from: self) { [weak self] in
            self?.showAlert(with: "User did earn reward, handle accordingly")
        }
    }
    
    private func makeRequest() {
        let request = Request()
        
        RewardedAd.load(
            with: Environment.current.rewardedUnitID,
            request: request
        ) { [weak self] rewarded, error in
            guard let self else {
                return
            }
            guard let rewarded else {
                self.switchState(to: .idle)
                self.showAlert(with: "Error occurred: \(error?.localizedDescription ?? "")")
                return
            }
            self.rewarded = rewarded
            rewarded.fullScreenContentDelegate = self
            self.switchState(to: .loaded)
        }
    }
    
    private func deleteLoadedAd() {
        rewarded = nil
    }
}

extension RewardedViewController: FullScreenContentDelegate {
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
