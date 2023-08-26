//
//  Data.swift
//  VenusWeatherMac
//
//  Created by Ibrahima Ciss on 25/08/2023.
//

import WeatherKit
import Foundation

// MARK: - DailyForecast
struct DailyForecast: Identifiable {
    let id: String
    let date: Date
    let imageName: String
    let condition: String
    let lowTemperature: String
    let highTempterature: String
}

extension DailyForecast {
    init(dayWeather: DayWeather) {
        self.id = UUID().uuidString
        self.date = dayWeather.date
        self.imageName = dayWeather.symbolName
        self.condition = dayWeather.condition.description
        self.lowTemperature = format(temperature: dayWeather.lowTemperature)
        self.highTempterature = format(temperature: dayWeather.highTemperature)
    }

    static let dummy = DailyForecast(
        id: UUID().uuidString,
        date: .now,
        imageName: "cloud.sun.bolt.fill",
        condition: "Partly cloudy",
        lowTemperature: "28.0º",
        highTempterature: "31.0º"
    )
}


// MARK: - HourlyForecast
struct HourlyForecast: Identifiable {
    let id: String
    let date: Date
    let wind: String
    let imageName: String
    let condition: String
    let temperature: String
    let precipitationChance: String
}

extension HourlyForecast {
    init(hourlyForecast: HourWeather) {
        self.id = UUID().uuidString
        self.date = hourlyForecast.date
        self.imageName = hourlyForecast.symbolName
        self.wind = hourlyForecast.wind.speed.formatted()
        self.condition = hourlyForecast.condition.description
        self.temperature = format(temperature: hourlyForecast.temperature)
        self.precipitationChance = format(precipitationChance: hourlyForecast.precipitationChance)
    }

    static let dummy = HourlyForecast(
        id: UUID().uuidString,
        date: .now,
        wind: "13km/h",
        imageName: "8%",
        condition: "cloud.sun.bolt.fill",
        temperature: "Partly cloudy",
        precipitationChance: "28.0º"
    )
}
