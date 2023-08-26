//
//  VenusModel.swift
//  VenusWeatherMac
//
//  Created by Ibrahima Ciss on 25/08/2023.
//

import Combine
import WeatherKit
import CoreLocation

@MainActor
final class VenusModel: ObservableObject {

    @Published var searchText = ""
    @Published var selectedLocation: CLLocation? = CLLocation(latitude: 14.77943584488948, longitude: -17.370824952178218)

    @Published private(set) var currentWeather: CurrentWeather?
    @Published private(set) var hourlyForecasts: [HourlyForecast] = []
    @Published private(set) var dailyForecasts: [DailyForecast] = []

    @Published private(set) var dailyForecast: DailyForecast?
    @Published private(set) var dateHourlyForecasts: [HourlyForecast] = []

    private let service = WeatherService.shared

    func getForecastForSelectedLocation() async {
        guard let selectedLocation else { return }
        let forecast = await Task.detached(priority: .userInitiated) {
            try? await self.service.weather(
                for: selectedLocation,
                including: .current, .hourly, .daily
            )
        }.value
        self.currentWeather = forecast?.0
        self.hourlyForecasts = forecast?.1.compactMap(HourlyForecast.init) ?? []
        self.dailyForecasts = forecast?.2.compactMap(DailyForecast.init) ?? []
    }

    func getHourlyForecastSelectedLocation(within date: Date) async {
        guard let selectedLocation else { return }
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
        let dateHourlyResponse = try? await self.service.weather(
            for: selectedLocation,
            including: .hourly(startDate: startDate, endDate: endDate ?? .now)
        )
        let dailyForeCastResponse = try? await self.service.weather(
            for: selectedLocation,
            including: .daily(startDate: startDate, endDate: endDate ?? .now)
        )
        self.dailyForecast = dailyForeCastResponse?.forecast.first.map(DailyForecast.init)
        self.dateHourlyForecasts = dateHourlyResponse?.forecast.compactMap(HourlyForecast.init) ?? []
    }
}
