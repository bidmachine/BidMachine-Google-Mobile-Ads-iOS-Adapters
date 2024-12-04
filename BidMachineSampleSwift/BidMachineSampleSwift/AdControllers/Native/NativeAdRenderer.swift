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
        
        if let mediaView = adView.mediaView {
            mediaView.mediaContent = ad.mediaContent
            let divider = ad.mediaContent.aspectRatio > 0 ? ad.mediaContent.aspectRatio : 1
            let aspectRatio = 1 / divider
            
            NSLayoutConstraint.activate(
                [mediaView.heightAnchor.constraint(equalTo: mediaView.widthAnchor, multiplier: aspectRatio)]
            )
        }

        adView.nativeAd = ad
        replaceNativeAdView(adView, in: view)
        
        (adView.storeView as? UILabel)?.text = ad.store
        adView.storeView?.isHidden = ad.store == nil

        (adView.priceView as? UILabel)?.text = ad.price
        adView.priceView?.isHidden = ad.price == nil
        
        (adView.advertiserView as? UILabel)?.text = ad.advertiser
        adView.advertiserView?.isHidden = ad.advertiser == nil
        
        (adView.headlineView as? UILabel)?.text = ad.headline
        adView.headlineView?.isHidden = ad.headline == nil
        
        (adView.callToActionView as? UILabel)?.text = ad.callToAction
        adView.callToActionView?.isHidden = ad.callToAction == nil
        
        (adView.iconView as? UIImageView)?.image = ad.icon?.image
        adView.iconView?.isHidden = ad.icon == nil
        
        (adView.bodyView as? UILabel)?.text = ad.body
        adView.bodyView?.isHidden = ad.body == nil
        
        let choicesView = GADAdChoicesView()
        choicesView.translatesAutoresizingMaskIntoConstraints = false
        choicesView.isUserInteractionEnabled = false

        adView.adChoicesView = choicesView
        adView.addSubview(choicesView)

        NSLayoutConstraint.activate([
            choicesView.topAnchor.constraint(equalTo: adView.topAnchor, constant: 8),
            choicesView.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -8),
            choicesView.widthAnchor.constraint(equalToConstant: 20),
            choicesView.heightAnchor.constraint(equalToConstant: 20)
        ])

        ad.register(
            adView,
            clickableAssetViews: [
                .headlineAsset: adView.headlineView,
                .mediaViewAsset: adView.mediaView,
                .callToActionAsset: adView.callToActionView
            ].compactMapValues { $0 },
            nonclickableAssetViews: [
                .iconAsset: adView.iconView,
                .bodyAsset: adView.bodyView,
                .adChoicesViewAsset: choicesView,
                .advertiserAsset: adView.advertiserView,
                .priceAsset: adView.priceView,
                .storeAsset: adView.storeView
            ].compactMapValues { $0 }
        )
    }
    
    private static func replaceNativeAdView(_ adView: UIView, in container: UIView) {
        container.subviews.forEach { $0.removeFromSuperview() }
        adView.stk_edgesEqual(container)
    }
}
