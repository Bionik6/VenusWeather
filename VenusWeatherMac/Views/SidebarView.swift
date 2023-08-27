import SwiftUI

struct SidebarView: View {
    @State private var attributionLink: URL?
    @State private var attributionLogo: URL?
    @ObservedObject private var model: VenusModel
    @Environment(\.colorScheme) private var colorScheme
    
    init(model: VenusModel) {
        self.model = model
    }
    
    var body: some View {
        ScrollView {
            ForEach(model.weatherLocations) { weatherLocation in
                LazyVStack {
                    FavoriteLocationView(weatherLocation: weatherLocation)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            guard let location = weatherLocation.venusLocation else { return }
                            Task { await model.select(location: location) }
                        }
                }
            }
        }
        Spacer()
        if let attributionLogo, let attributionLink {
            VStack {
                AsyncImage(url: attributionLogo) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                } placeholder: {
                    EmptyView()
                }
                Link("Other data sources", destination: attributionLink)
                    .font(.miniMedium)
            }
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(model: .init())
    }
}


struct FavoriteLocationView: View {
    let weatherLocation: WeatherLocation

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(weatherLocation.venusLocation?.city ?? "")
                    .font(.mainMedium)
                Spacer()
                if let currentTemperature = weatherLocation.currentTemperatureValue {
                    Label(
                        format(temperature: currentTemperature),
                        systemImage: weatherLocation.imageName
                    )
                    .symbolVariant(.fill)
                    .symbolRenderingMode(.multicolor)
                    .font(.h6Medium)
                }
            }
            HStack {
                Text(weatherLocation.condition)
                    .font(.mini)
                    .foregroundColor(.primary.opacity(0.6))
                Spacer()
                Text(weatherLocation.lowHighTemperature)
                    .font(.subText)
                    .foregroundColor(.primary.opacity(0.6))
            }
            Divider()
        }
        .padding(.horizontal, 16)
    }
}
