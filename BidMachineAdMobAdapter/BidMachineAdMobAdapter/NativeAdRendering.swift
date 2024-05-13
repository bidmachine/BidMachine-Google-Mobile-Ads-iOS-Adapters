//
//  NativeAdRendering.swift
//  BidMachineAdMobAdapter
//
//  Created by Ilia Lozhkin on 20.12.2022.
//

import Foundation
import BidMachine
import GoogleMobileAds


class NativeAdRendering: BidMachineNativeAdRendering {
    
    var titleLabel: UILabel?
    
    var callToActionLabel: UILabel?
    
    var descriptionLabel: UILabel?
    
    var iconView: UIImageView?
    
    var mediaContainerView: UIView?
    
    var adChoiceView: UIView?
    
    init(_ assets: [GADNativeAssetIdentifier : UIView]) {
        self.titleLabel = assets[.headlineAsset] as? UILabel
        self.callToActionLabel = assets[.callToActionAsset] as? UILabel
        self.descriptionLabel = assets[.bodyAsset] as? UILabel
        self.iconView = assets[.iconAsset] as? UIImageView
        self.mediaContainerView = assets[.mediaViewAsset]
        self.adChoiceView = assets[.adChoicesViewAsset]
    }
}
