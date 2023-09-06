import SwiftUI
import WeatherKit
import CoreLocation

struct ContentView: View {
    @ObservedObject private var model: VenusModel

    init(model: VenusModel) {
        self.model = model
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BETWEEN_SECTION_SPACING) {
                HEADER

                MAIN_CARD

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
            Text(title.uppercased())
                .font(.subTextMedium)
                .foregroundColor(.primary.opacity(0.8))
            Label(value, systemImage: iconName)
                .font(.main)
                .redactAndShimmer(condition: model.isLoadingForecast)
        }
    }

    private var HEADER: some View {
        HStack(alignment: .center, spacing: 12) { // Header
            Text(model.selectedLocation.fullName)
                .foregroundStyle(.primary)
                .font(.largeTitle)
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
                            Task {
                                await model.getHourlyForecastSelectedLocation(within: forecast.date)
                            }
                        } label: {
                            DailyForecastView(dailyForecast: forecast)
                                .redactAndShimmer(condition: model.isLoadingForecast)
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
                            .redactAndShimmer(condition: model.isLoadingForecast)
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
        ScrollView(.horizontal) {
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
                    .redactAndShimmer(condition: model.isLoadingForecast)

                    if let currentWeather = model.currentWeather {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(currentWeather.condition.description)
                            Text("Feels like \(format(temperature: currentWeather.apparentTemperature))")
                        }
                        .font(.h6)
                    }
                }

                Text("The skies will be partly cloudy. The low will be 15º")
                    .font(.main)

                if let currentWeather = model.currentWeather {
                    HStack(spacing: 32) {
                        makeDetails(
                            title: "Wind",
                            iconName: "wind",
                            value: currentWeather.wind.speed.formatted()
                        )
                        makeDetails(
                            title: "Humidity",
                            iconName: "drop",
                            value: formatToPercent(value: currentWeather.humidity)
                        )
                        makeDetails(
                            title: "Visibility",
                            iconName: "eye",
                            value: currentWeather.visibility.formatted()
                        )
                        makeDetails(
                            title: "Presssure",
                            iconName: "speedometer",
                            value: format(pressure: currentWeather.pressure)
                        )
                        makeDetails(
                            title: "UV Index",
                            iconName: "sun.max.fill",
                            value: "\(currentWeather.uvIndex.value)"
                        )
                        makeDetails(
                            title: "Sunrise",
                            iconName: "sunrise.fill",
                            value: format(hour: model.todayWeather?.sun.sunrise ?? .now)
                        )
                        makeDetails(
                            title: "Sunset",
                            iconName: "sunset.fill",
                            value: format(hour: model.todayWeather?.sun.sunset ?? .now)
                        )
                    }
                } else {
                    HStack(spacing: 32) {
                        makeDetails(title: "Wind", iconName: "wind", value: "")
                        makeDetails(title: "Humidity", iconName: "drop", value: "")
                        makeDetails(title: "Visibility", iconName: "eye", value: "")
                        makeDetails(title: "Presssure", iconName: "speedometer", value: "")
                        makeDetails(title: "UV Index", iconName: "sun.max.fill", value: "")
                    }
                    .redacted(reason: .placeholder)
                }
            }
            .padding(24)
            .blurBackground()
        }
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: .init())
    }
}
