import Combine
import SwiftUI
import WeatherKit
import CoreLocation

@MainActor
final class VenusModel: ObservableObject {
    private(set) var service = WeatherService.shared

    @Published var selectedLocation: VenusLocation = VenusLocation(
        latitude: 14.77943584488948,
        longitute: -17.370824952178218,
        city: "Guediawaye",
        country: "Senegal"
    )

    var isLoadingForecast = false
    var isLoadingHourlyForecast = false
    @Published var showRightPane = false 
    @Published private(set) var favoriteLocations: [FavoriteLocation] = []

    @Published private(set) var todayWeather: DayWeather?
    @Published private(set) var currentWeather: CurrentWeather?
    @Published private(set) var dailyForecasts: [DailyForecast] = .sample
    @Published private(set) var hourlyForecasts: [HourlyForecast] = .sample

    @Published private(set) var dailyForecast: DailyForecast?
    @Published private(set) var dateHourlyForecasts: [HourlyForecast] = .sample

    func getFavoriteLocations() {
        self.favoriteLocations = PersistenceController.shared.getAllLocations()
    }

    func getForecastForSelectedLocation() async {
        self.showRightPane = false
        isLoadingForecast = true
        defer { isLoadingForecast = false }
        let todayDate = Calendar.current.startOfDay(for: .now)
        let forecast = try? await self.service.weather(
            for: selectedLocation.clLocation,
            including: .current, .hourly, .daily
        )
        let dayWeather = forecast?.2.filter { $0.date >= todayDate } ?? []
        self.currentWeather = forecast?.0
        self.hourlyForecasts = forecast?.1.compactMap(HourlyForecast.init) ?? []
        self.dailyForecasts = dayWeather.map(DailyForecast.init)
        self.todayWeather = dayWeather.first
    }

    func getHourlyForecastSelectedLocation(within date: Date) async {
        self.showRightPane = true
        self.isLoadingHourlyForecast = true
        defer { isLoadingHourlyForecast = false }
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
        async let dateHourlyResponse = try? await self.service.weather(
            for: selectedLocation.clLocation,
            including: .hourly(startDate: startDate, endDate: endDate ?? .now)
        )
        async let dailyForeCastResponse = try? await self.service.weather(
            for: selectedLocation.clLocation,
            including: .daily(startDate: startDate, endDate: endDate ?? .now)
        )
        let result = await (dateHourlyResponse, dailyForeCastResponse)
        self.dailyForecast = result.1?.forecast.first.map(DailyForecast.init)
        self.dateHourlyForecasts = result.0?.forecast.compactMap(HourlyForecast.init) ?? []
    }

    func select(location: VenusLocation) async {
        self.selectedLocation = location
        await getForecastForSelectedLocation()
        dailyForecast = nil
        dateHourlyForecasts = []
        if PersistenceController.shared.findWeatherLocation(from: location) != nil {
            saveLocation()
        }
    }

    func saveLocation() {
        guard let todayWeather, let currentWeather else {
            print("Can't get today/current weather")
            return
        }
        guard let weatherLocation = PersistenceController.shared.save(
            weather: todayWeather,
            location: selectedLocation,
            currentWeather: currentWeather
        ) else { return }
        if let idx = favoriteLocations.lazy.firstIndex(where: { $0.identifier == weatherLocation.identifier }) {
            let location = FavoriteLocation(weatherLocation: weatherLocation)
            favoriteLocations[idx] = location
        } else {
            let location = FavoriteLocation(weatherLocation: weatherLocation)
            favoriteLocations.append(location)
        }
    }

    func removeLocation() {
        let result = PersistenceController
            .shared
            .deleteWeatherLocation(selectedLocation)
        if result {
            favoriteLocations.removeAll { $0.identifier == selectedLocation.id }
        }
    }
}
