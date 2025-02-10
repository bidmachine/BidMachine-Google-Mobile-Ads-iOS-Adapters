//
//  Copyright © 2024 Appodeal. All rights reserved.
//

import UIKit
import GoogleMobileAds
import BidMachineAdMobAdapter
import BidMachine

final class NativeViewController: AdLoadController {
    override var topTitle: String? {
        "Native"
    }
    
    private var nativeAd: NativeAd?
    private let container = UIView()

    private lazy var nativeLoader = {
        let mediaOptions = NativeAdMediaAdLoaderOptions()
        mediaOptions.mediaAspectRatio = .landscape
        
        let videoOptions = VideoOptions()
        videoOptions.shouldStartMuted = true
        
        let viewOptions = NativeAdViewAdOptions()
        viewOptions.preferredAdChoicesPosition = .topRightCorner

        let loader = AdLoader(
            adUnitID: Environment.current.nativeUnitID,
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
        makeRequest()
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
        let request = Request()
        nativeLoader.load(request)
    }
    
    private func deleteLoadedAd() {
        if let nativeAd {
            NativeAdRenderer.unregister(ad: nativeAd, from: container)
        }
        nativeAd = nil
    }
}

extension NativeViewController: NativeAdLoaderDelegate {
    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: any Error) {
        print("[DEBUG]: didFailToReceiveAdWithError")
        switchState(to: .idle)
        showAlert(with: "Failed to receive ad: \(error.localizedDescription)")
    }
    
    func adLoaderDidFinishLoading(_ adLoader: AdLoader) {
        print("[DEBUG]: adLoaderDidFinishLoading")
    }
    
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        print("[DEBUG]: didReceive nativeAd")
        switchState(to: .loaded)
        self.nativeAd = nativeAd
    }
}

extension NativeViewController: NativeAdDelegate {
    func nativeAdDidRecordImpression(_ nativeAd: NativeAd) {
        print("[DEBUG]: nativeAdDidRecordImpression")
    }
    
    func nativeAdDidRecordClick(_ nativeAd: NativeAd) {
        print("[DEBUG]: nativeAdDidRecordClick")
    }
}
