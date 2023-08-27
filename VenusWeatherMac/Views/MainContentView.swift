import SwiftUI
import WeatherKit
import CoreLocation

struct MainContentView: View {
    @ObservedObject private var model: VenusModel

    init(model: VenusModel) {
        self.model = model
    }

    @State private var selection: Int = 1
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BETWEEN_SECTION_SPACING) {

                HEADER

                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        MAIN_CARD
                        VStack {
                        }
                    }
                }

                TEN_DAYS_FORECAST_VIEW

                HOURLY_FORECAST_VIEW
            }
            .foregroundColor(.primary)
            .frame(maxWidth: 1200)
            .padding(16)
        }
    }

    @ViewBuilder
    private func makeDetails(title: String, iconName: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: iconName).font(.subText)
                Text(title).font(.subText)
            }
            Text(value).font(.main)
        }
    }

    private var HEADER: some View {
        HStack(alignment: .center, spacing: 12) { // Header
            Text(model.selectedLocation.fullName)
                .foregroundStyle(.primary)
                .font(.largeTitle)
            Button(action: { withAnimation { model.saveLocation() } }) {
                Image(systemName: "mappin.circle.fill")
                    .font(.largeTitle)
                    .symbolVariant(.fill)
            }
            .buttonStyle(.plain)
            .help("Pin location")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var TEN_DAYS_FORECAST_VIEW: some View {
        VStack(alignment: .leading, spacing: TITLE_PADDING) {
            Text("10 days forecast".uppercased())
                .font(.mainBold)

            ScrollView(.horizontal) {
                LazyHStack(spacing: 10) {
                    ForEach(model.dailyForecasts) { forecast in
                        Button {
                            Task { await model.getHourlyForecastSelectedLocation(within: forecast.date) }
                        } label: {
                            DailyForecastView(dailyForecast: forecast)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .frame(maxHeight: 200).fixedSize(horizontal: false, vertical: true)
            .scrollIndicators(.hidden)
        }
    }

    private var HOURLY_FORECAST_VIEW: some View {
        VStack(alignment: .leading, spacing: TITLE_PADDING) {
            Text("Hourly forecast".uppercased())
                .font(.mainBold)

            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(model.hourlyForecasts) {
                        HourlyForecastView(hourlyForecast: $0)
                    }
                }
            }
            .frame(maxHeight: 324).fixedSize(horizontal: false, vertical: true)
            .scrollIndicators(.hidden)
            .background(
                LinearGradient(gradient: Gradient(colors: [.primary.opacity(0.05), .primary.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    private var MAIN_CARD: some View {
        VStack(alignment: .leading, spacing: 28) { //
            Text("Current Weather")
                .font(.title)
                .fontWeight(.medium)

            HStack(spacing: 24) {
                Image(systemName: model.currentWeather?.symbolName ?? "cloud.sun.fill")
                    .symbolRenderingMode(.multicolor)
                    .symbolVariant(.fill)
                    .font(.system(size: 80))
                    .foregroundStyle(.primary)
                Group {
                    if let temperature = model.currentWeather?.temperature {
                        Text(format(temperature: temperature))
                    } else {
                        Text("---")
                    }
                }
                .font(.system(size: 70))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Mostly cloudy")
                    Text("Feels like 18º")
                }
                .font(.h6)
            }

            Text("The skies will be partly cloudy. The low will be 15º")
                .font(.main)

            HStack(spacing: 24) {
                makeDetails(title: "Wind", iconName: "wind", value: "16 km/h")
                makeDetails(title: "Humidity", iconName: "drop", value: "87%")
                makeDetails(title: "Visibility", iconName: "eye", value: "10km")
                makeDetails(title: "Presssure", iconName: "speedometer", value: "1019mb")
                makeDetails(title: "UV Index", iconName: "sun.max.fill", value: "0")
            }
        }
        .padding(24)
        .blurBackground()
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView(model: .init())
    }
}
