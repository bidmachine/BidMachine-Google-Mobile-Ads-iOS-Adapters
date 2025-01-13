//
//  Copyright © 2024 Appodeal. All rights reserved.
//

import UIKit
import GoogleMobileAds
import BidMachineAdMobAdapter
import BidMachine

final class BannerViewController: AdLoadController {
    private var googleBanner: GADBannerView?

    override var topTitle: String? {
        "Banner"
    }

    private let bannerContainer = UIView()

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
        makeRequest()
    }
    
    override func showAd() {
        switchState(to: .idle)

        guard let googleBanner else {
            showAlert(with: "No banner to show")
            return
        }
        
        let bannerSize = googleBanner.adSize.size

        bannerContainer.addSubview(googleBanner)
        googleBanner.translatesAutoresizingMaskIntoConstraints = false
        
        googleBanner.stk_edgesEqual(bannerContainer)

        NSLayoutConstraint.activate([
            googleBanner.heightAnchor.constraint(equalToConstant: bannerSize.height),
            googleBanner.widthAnchor.constraint(equalToConstant: bannerSize.width)
        ])
    }

    private func makeRequest() {
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        self.googleBanner = banner

        banner.delegate = self
        banner.adUnitID = Environment.current.bannerUnitID
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
        print("[DEBUG]: bannerViewDidReceiveAd")
        switchState(to: .loaded)
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: any Error) {
        print("[DEBUG]: didFailToReceiveAdWithError")
        switchState(to: .idle)
        showAlert(with: "Error occurred: \(error.localizedDescription)")
    }
}
