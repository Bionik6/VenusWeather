import SwiftUI

@main
struct VenusWeatherMacApp: App {

    var body: some Scene {
        WindowGroup {
            MainView(model: .init(), searchModel: .init())
                .frame(minWidth: 1200, minHeight: 800)
        }
    }
}
