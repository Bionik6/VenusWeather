import Combine
import WeatherKit
import CoreLocation

@MainActor
final class VenusModel: ObservableObject {
    private(set) var service = WeatherService.shared

    private(set) var selectedLocation: VenusLocation = VenusLocation(
        latitude: 14.77943584488948,
        longitute: -17.370824952178218,
        city: "Guediawaye",
        country: "Senegal"
    )

    @Published private(set) var currentWeather: CurrentWeather?
    @Published private(set) var dailyForecasts: [DailyForecast] = []
    @Published private(set) var hourlyForecasts: [HourlyForecast] = []

    @Published private(set) var dailyForecast: DailyForecast?
    @Published private(set) var dateHourlyForecasts: [HourlyForecast] = []

    func getForecastForSelectedLocation() async {
        let forecast = await Task.detached(priority: .userInitiated) { [location = selectedLocation.clLocation] in
            try? await self.service.weather(
                for: location,
                including: .current, .hourly, .daily
            )
        }.value
        self.currentWeather = forecast?.0
        self.hourlyForecasts = forecast?.1.compactMap(HourlyForecast.init) ?? []
        self.dailyForecasts = forecast?.2.compactMap(DailyForecast.init) ?? []
    }

    func getHourlyForecastSelectedLocation(within date: Date) async {

        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
        let dateHourlyResponse = try? await self.service.weather(
            for: selectedLocation.clLocation,
            including: .hourly(startDate: startDate, endDate: endDate ?? .now)
        )
        let dailyForeCastResponse = try? await self.service.weather(
            for: selectedLocation.clLocation,
            including: .daily(startDate: startDate, endDate: endDate ?? .now)
        )
        self.dailyForecast = dailyForeCastResponse?.forecast.first.map(DailyForecast.init)
        self.dateHourlyForecasts = dateHourlyResponse?.forecast.compactMap(HourlyForecast.init) ?? []
    }

    func select(location: VenusLocation) async {
        self.selectedLocation = location
        await getForecastForSelectedLocation()
        dailyForecast = nil
        dateHourlyForecasts = []
    }
}
