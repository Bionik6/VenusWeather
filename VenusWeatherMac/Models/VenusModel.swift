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

    @Published var showRightPane = false 
    @Published private(set) var weatherLocations: [WeatherLocation] = []

    @Published private(set) var todayWeather: DayWeather?
    @Published private(set) var currentWeather: CurrentWeather?
    @Published private(set) var dailyForecasts: [DailyForecast] = []
    @Published private(set) var hourlyForecasts: [HourlyForecast] = []

    @Published private(set) var dailyForecast: DailyForecast?
    @Published private(set) var dateHourlyForecasts: [HourlyForecast] = []

    func getFavoriteLocations() {
        self.weatherLocations = PersistenceController.shared.getAllLocations()
    }

    func getForecastForSelectedLocation() async {
        self.showRightPane = false
        let todayDate = Calendar.current.startOfDay(for: .now)
        let forecast = await Task.detached(priority: .userInitiated) { [location = selectedLocation.clLocation] in
            try? await self.service.weather(
                for: location,
                including: .current, .hourly, .daily
            )
        }.value
        let dayWeather = forecast?.2.filter { $0.date >= todayDate } ?? []
        self.currentWeather = forecast?.0
        self.hourlyForecasts = forecast?.1.compactMap(HourlyForecast.init) ?? []
        self.dailyForecasts = dayWeather.map(DailyForecast.init)
        self.todayWeather = dayWeather.first
    }

    func getHourlyForecastSelectedLocation(within date: Date) async {
        self.showRightPane = true
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

    func saveLocation() {
        guard let todayWeather, let currentWeather else {
            print("Can't get today/current weather")
            return
        }
        PersistenceController.shared.save(
            weather: todayWeather,
            location: selectedLocation,
            currentWeather: currentWeather
        )
        getFavoriteLocations()
    }

    func removeLocation() {
        // guard let
    }
}

