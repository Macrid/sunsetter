//
//  SunsetterApp.swift
//  Sunsetter
//
//  Created by Erik Persson on 2020-11-20.
//

import SwiftUI
//import GoogleMobileAds

@main
struct SunsetterApp: App {
    init() {
       // GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            BeforeStartView()
        }
    }
}
