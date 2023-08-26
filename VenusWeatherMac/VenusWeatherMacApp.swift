//
//  VenusWeatherMacApp.swift
//  VenusWeatherMac
//
//  Created by Ibrahima Ciss on 19/08/2023.
//

import SwiftUI

@main
struct VenusWeatherMacApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView(model: .init())
                .frame(minWidth: 1200, minHeight: 800)
        }
    }
}
