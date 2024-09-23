//
//  Copyright © 2024 Appodeal. All rights reserved.
//

import UIKit
import GoogleMobileAds
import BidMachineAdMobAdapter
import BidMachine

private enum Constant {
    static let unitId = "ca-app-pub-3216013768320747/7699763218" // "your unit id here"
}

final class NativeViewController: AdLoadController {
    override var topTitle: String? {
        "Native"
    }
    
    private var nativeAd: GADNativeAd?
    private let container = UIView()

    private lazy var nativeLoader = {
        let mediaOptions = GADNativeAdMediaAdLoaderOptions()
        mediaOptions.mediaAspectRatio = .landscape
        
        let videoOptions = GADVideoOptions()
        videoOptions.startMuted = true
        
        let viewOptions = GADNativeAdViewAdOptions()
        viewOptions.preferredAdChoicesPosition = .topRightCorner

        let loader = GADAdLoader(
            adUnitID: Constant.unitId,
            rootViewController: self,
            adTypes: [.native],
            options: [
                viewOptions,
                videoOptions,
                mediaOptions
            ]
        )
        loader.delegate = self
        
        return loader
    }()
    
    override func layoutContent() {
        super.layoutContent()
        
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor, constant: 5.0),
            container.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor, constant: -5.0),
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            container.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor)
        ])
    }
    
    override func loadAd() {
        deleteLoadedAd()
        switchState(to: .loading)
        
        BidMachineSdk.shared.native { [weak self] nativeAd, error in
            AdMobAdapter.store(nativeAd)
            self?.makeRequest()
        }
    }
    
    override func showAd() {
        switchState(to: .idle)
        
        guard let nativeAd else {
            showAlert(with: "No native ad to show")
            return
        }
        nativeAd.delegate = self
        nativeAd.rootViewController = self
        
        NativeAdRenderer.render(ad: nativeAd, in: container)
    }
    
    private func makeRequest() {
        let request = GADRequest()
        nativeLoader.load(request)
    }
    
    private func deleteLoadedAd() {
        if let nativeAd {
            NativeAdRenderer.unregister(ad: nativeAd, from: container)
        }
        nativeAd = nil
    }
}

extension NativeViewController: GADNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: any Error) {
        switchState(to: .idle)
        showAlert(with: "Failed to receive ad: \(error.localizedDescription)")
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        switchState(to: .loaded)
        self.nativeAd = nativeAd
    }
}

extension NativeViewController: GADNativeAdDelegate {
    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        
    }
    
    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        
    }
}
