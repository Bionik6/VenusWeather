import SwiftUI

struct HourlyForecastRow: View {
    @State private var showDetails = false
    private let hourlyForecast: HourlyForecast

    init(hourlyForecast: HourlyForecast) {
        self.hourlyForecast = hourlyForecast
    }

    var body: some View {
        GridRow {
            Text(format(hour: hourlyForecast.date))
                .help("Time")
                .font(.main)
            Label(hourlyForecast.temperature, systemImage: hourlyForecast.imageName)
                .font(.main)
                .symbolVariant(.fill)
                .symbolRenderingMode(.multicolor)
                .help("Chance of precipitation")
            Label(hourlyForecast.wind, systemImage: "wind")
                .font(.subText)
                .help("Wind speed")
            Button(action: { withAnimation { showDetails.toggle() } }) {
                Image(systemName: "chevron.down.circle.fill")
                    .font(.h6)
                    .foregroundColor(.secondary)
                    .rotationEffect(.degrees(showDetails ? 180 : 0))
            }
            .frame(width: 32, height: 32)
            .buttonStyle(.plain)
            .gridCellUnsizedAxes(.horizontal)
        }
        if !showDetails {
            Divider()
                .frame(maxWidth: .infinity)
        }
        if showDetails {
            VStack(alignment: .leading) {
                Text(hourlyForecast.condition)
                    .font(.mainMedium)
                    .help("Weather condition")
                    .padding(.bottom, 12)
                Grid(verticalSpacing: 12) {
                    GridRow {
                        HourlyForecastRowDetailView(title: "Feels Like", value: hourlyForecast.feelsLike)
                        HourlyForecastRowDetailView(title: "Cloud Cover", value: hourlyForecast.cloudCover)
                        HourlyForecastRowDetailView(title: "Visibility", value: hourlyForecast.visibility)
                        HourlyForecastRowDetailView(title: "Wind Gust", value: hourlyForecast.windGust)
                    }
                    GridRow {
                        HourlyForecastRowDetailView(title: "Pressure", value: hourlyForecast.pressure)
                        HourlyForecastRowDetailView(title: "Humidity", value: hourlyForecast.humidity)
                        HourlyForecastRowDetailView(title: "Dew Point", value: hourlyForecast.dewPoint)
                        HourlyForecastRowDetailView(title: "UV Index", value: hourlyForecast.uvIndex)
                    }
                }
            }
            Divider()
        }
    }
}

struct HourlyForecastRowDetailView: View {
    private let title: String
    private let value: String

    init(title: String, value: String) {
        self.title = title
        self.value = value
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .foregroundColor(.secondary)
                .font(.mini)
            Text(value)
                .foregroundColor(.primary)
                .font(.mainMedium)
        }
    }
}
