//
//  Adview.swift
//  Sunsetter
//
//  Created by Erik Persson on 2020-12-11.
//

import Foundation
import SwiftUI
import GoogleMobileAds

struct Adview : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<Adview>) -> GADBannerView {
        let banner = GADBannerView(adSize: kGADAdSizeBanner)
        
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        return banner
    }
    
    func updateUIView(_ uiView: GADBannerView, context: UIViewRepresentableContext<Adview>) {
        
    }
}
