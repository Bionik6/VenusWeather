import SwiftUI

@main
struct VenusWeatherMacApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView(model: .init(), searchModel: .init())
                .frame(minWidth: 1200, minHeight: 800)
        }
    }
}
