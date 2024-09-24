//
//  Copyright © 2024 Appodeal. All rights reserved.
//

import UIKit
import GoogleMobileAds
import BidMachineAdMobAdapter
import BidMachine

private enum Constant {
    static let unitID = "ca-app-pub-3216013768320747/5715655753" // "your unit id here"
}

final class BannerViewController: AdLoadController {
    override var topTitle: String? {
        "Banner"
    }

    private let bannerContainer = UIView()
    private var googleBanner: GADBannerView?

    override func layoutContent() {
        super.layoutContent()
        
        bannerContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerContainer)
        
        NSLayoutConstraint.activate([
            bannerContainer.centerXAnchor.constraint(equalTo: contentLayoutGuide.centerXAnchor),
            bannerContainer.widthAnchor.constraint(lessThanOrEqualTo: contentLayoutGuide.widthAnchor),
            bannerContainer.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor, constant: -20),
            bannerContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }

    override func loadAd() {
        deleteLoadedAd()
        switchState(to: .loading)
        
        do {
            let config = try BidMachineSdk.shared.requestConfiguration(.banner320x50)

            BidMachineSdk.shared.banner(config) { [weak self] banner, error in
                guard let self else {
                    return
                }
                if let error {
                    self.switchState(to: .idle)
                    self.showAlert(with: error.localizedDescription)
                } else {
                    AdMobAdapter.store(banner)
                    self.makeRequest()
                }
            }
        } catch let error {
            showAlert(with: "Error occurred: \(error.localizedDescription)")
            switchState(to: .idle)
        }
    }
    
    override func showAd() {
        switchState(to: .idle)

        guard let googleBanner else {
            showAlert(with: "No banner to show")
            return
        }

        bannerContainer.addSubview(googleBanner)
        googleBanner.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            googleBanner.topAnchor.constraint(equalTo: bannerContainer.topAnchor),
            googleBanner.leftAnchor.constraint(equalTo: bannerContainer.leftAnchor),
            googleBanner.bottomAnchor.constraint(equalTo: bannerContainer.bottomAnchor),
            googleBanner.rightAnchor.constraint(equalTo: bannerContainer.rightAnchor),
            googleBanner.heightAnchor.constraint(equalToConstant: 50),
            googleBanner.widthAnchor.constraint(equalToConstant: 320)
        ])
    }

    private func makeRequest() {
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        self.googleBanner = banner

        banner.delegate = self
        banner.adUnitID = Constant.unitID
        banner.rootViewController = self
        banner.load(GADRequest())
    }

    private func deleteLoadedAd() {
        bannerContainer.subviews.forEach { $0.removeFromSuperview() }
        googleBanner = nil
    }
}

extension BannerViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        switchState(to: .loaded)
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: any Error) {
        switchState(to: .idle)
        showAlert(with: "Error occurred: \(error.localizedDescription)")
    }
}
