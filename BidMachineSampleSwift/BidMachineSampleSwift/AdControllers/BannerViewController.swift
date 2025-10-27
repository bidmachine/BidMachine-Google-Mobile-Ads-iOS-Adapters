//
//  Copyright © 2024 Appodeal. All rights reserved.
//

import UIKit
import GoogleMobileAds
import BidMachineAdMobAdapter
import BidMachine

final class BannerViewController: AdLoadController {
    override var topTitle: String? {
        "Banner"
    }

    private let bannerContainer = UIView()
    private var googleBanner: BannerView?

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
            let placement = try BidMachineSdk.shared.placement(.banner320x50)
            let request = BidMachineSdk.shared.auctionRequest(placement: placement)

            BidMachineSdk.shared.banner(request: request) { [weak self] banner, error in
                guard let self else {
                    return
                }
                guard let banner else {
                    self.switchState(to: .idle)
                    showAlert(with: "Error occurred: \(error?.localizedDescription ?? "")")
                    return
                }
                AdMobAdapter.store(banner)
                self.makeRequest()
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
        let banner = BannerView(adSize: AdSizeBanner)
        self.googleBanner = banner

        banner.delegate = self
        banner.adUnitID = Environment.current.bannerUnitID
        banner.rootViewController = self
        banner.load(Request())
    }

    private func deleteLoadedAd() {
        bannerContainer.subviews.forEach { $0.removeFromSuperview() }
        googleBanner = nil
    }
}

extension BannerViewController: BannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        print("[DEBUG]: bannerViewDidReceiveAd")
        switchState(to: .loaded)
    }
    
    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: any Error) {
        print("[DEBUG]: didFailToReceiveAdWithError")
        switchState(to: .idle)
        showAlert(with: "Error occurred: \(error.localizedDescription)")
    }
}
