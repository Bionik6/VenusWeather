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

    @Published private(set) var currentWeather: CurrentWeather?
    @Published private(set) var hourlyForecasts: [HourlyForecast] = []
    @Published private(set) var dailyForecasts: [DailyForecast] = []
    @Published private(set) var weatherAlerts: [WeatherAlert] = []
    private let service = WeatherService.shared

    func weather(for location: CLLocation) async {
        let forecast = await Task.detached(priority: .userInitiated) {
            try? await self.service.weather(
                for: location,
                including: .current, .hourly, .daily, .alerts
            )
        }.value
        self.currentWeather = forecast?.0
        self.hourlyForecasts = forecast?.1.compactMap(HourlyForecast.init) ?? []
        self.dailyForecasts = forecast?.2.compactMap(DailyForecast.init) ?? []
        self.weatherAlerts = forecast?.3 ?? []
    }
}
