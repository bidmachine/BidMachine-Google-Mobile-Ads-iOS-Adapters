//
//  Copyright © 2024 Appodeal. All rights reserved.
//

import UIKit
import GoogleMobileAds

final class NativeAdRenderer {
    static func unregister(ad: GADNativeAd, from view: UIView) {
        ad.unregisterAdView()
        view.subviews.forEach { $0.removeFromSuperview() }
    }
    
    static func render(ad: GADNativeAd, in view: UIView) {
        ad.unregisterAdView()

        guard let adView = NativeAdView.instantiateFromNib(owner: nil) else {
            return
        }
        ad.register(
            adView,
            clickableAssetViews: [
                .headlineAsset: adView.headlineView,
                .callToActionAsset: adView.callToActionView
            ].compactMapValues { $0 },
            nonclickableAssetViews: [
                .mediaViewAsset: adView.mediaView,
                .iconAsset: adView.iconView,
                .bodyAsset: adView.bodyView
            ].compactMapValues { $0 }
        )
        adView.nativeAd = ad
        replaceNativeAdView(adView, in: view)
        
        (adView.storeView as? UILabel)?.text = ad.store
        adView.storeView?.isHidden = ad.store == nil

        (adView.priceView as? UILabel)?.text = ad.price
        adView.priceView?.isHidden = ad.price == nil
        
        (adView.advertiserView as? UILabel)?.text = ad.advertiser
        adView.advertiserView?.isHidden = ad.advertiser == nil
    }
    
    private static func replaceNativeAdView(_ adView: UIView, in container: UIView) {
        container.subviews.forEach { $0.removeFromSuperview() }
        
        container.addSubview(adView)
        adView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            adView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            adView.topAnchor.constraint(equalTo: container.topAnchor),
            adView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}
