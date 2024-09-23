//
//  Copyright © 2024 Appodeal. All rights reserved.
//

import UIKit
import BidMachine
import BidMachineAdMobAdapter
import GoogleMobileAds

private enum Constant {
    static let unitID = "ca-app-pub-3216013768320747/1325926558" // "your unit id here"
}

final class RewardedViewController: AdLoadController {
    private var rewarded: GADRewardedAd?
    
    override var topTitle: String? {
        "Rewarded"
    }

    override func loadAd() {
        deleteLoadedAd()
        switchState(to: .loading)
        
        BidMachineSdk.shared.rewarded { [weak self] rewarded, error in
            if let error {
                self?.switchState(to: .idle)
                self?.showAlert(with: error.localizedDescription)
            } else {
                AdMobAdapter.store(rewarded)
                self?.makeRequest()
            }
        }
    }
    
    override func showAd() {
        switchState(to: .idle)
        
        guard let rewarded else {
            showAlert(with: "No rewarded to show")
            return
        }
        rewarded.present(fromRootViewController: self) { [weak self] in
            self?.showAlert(with: "User did earn reward, handle accordingly")
        }
    }
    
    private func makeRequest() {
        let request = GADRequest()
        
        GADRewardedAd.load(
            withAdUnitID: Constant.unitID,
            request: request
        ) { [weak self] rewarded, error in
            if let error {
                self?.switchState(to: .idle)
                self?.showAlert(with: "Error occurred: \(error.localizedDescription)")
            } else {
                self?.rewarded = rewarded
                self?.rewarded?.fullScreenContentDelegate = self
                self?.switchState(to: .loaded)
            }
        }
    }
    
    private func deleteLoadedAd() {
        rewarded = nil
    }
}

extension RewardedViewController: GADFullScreenContentDelegate {
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
