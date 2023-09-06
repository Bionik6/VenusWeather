import Foundation
import WeatherKit

struct HourlyForecast: Identifiable, Sendable {
    let id: String
    let date: Date
    let wind: String
    let uvIndex: String
    let windGust: String
    let pressure: String
    let humidity: String
    let dewPoint: String
    let feelsLike: String
    let imageName: String
    let condition: String
    let cloudCover: String
    let visibility: String
    let temperature: String
    let precipitationChance: String
}

extension HourlyForecast {
    init(hourlyForecast: HourWeather) {
        self.id = UUID().uuidString
        self.date = hourlyForecast.date
        self.wind = hourlyForecast.wind.speed.formatted()
        self.windGust = hourlyForecast.wind.gust?.formatted() ?? "0 km/h"
        self.pressure = format(pressure: hourlyForecast.pressure)
        self.cloudCover = formatToPercent(value: hourlyForecast.cloudCover)
        self.visibility = hourlyForecast.visibility.formatted()
        self.humidity = formatToPercent(value: hourlyForecast.humidity)
        self.dewPoint = format(temperature: hourlyForecast.dewPoint)
        self.imageName = hourlyForecast.symbolName
        self.feelsLike = format(temperature: hourlyForecast.apparentTemperature)
        self.condition = hourlyForecast.condition.description
        self.uvIndex = hourlyForecast.uvIndex.value.description
        self.temperature = format(temperature: hourlyForecast.temperature)
        self.precipitationChance = formatToPercent(value: hourlyForecast.precipitationChance)
    }
}

extension Array where Element == HourlyForecast {
    static let sample = [
        HourlyForecast.dummy(),
        HourlyForecast.dummy(),
        HourlyForecast.dummy(),
        HourlyForecast.dummy(),
        HourlyForecast.dummy(),
        HourlyForecast.dummy(),
        HourlyForecast.dummy(),
        HourlyForecast.dummy(),
        HourlyForecast.dummy(),
        HourlyForecast.dummy(),
        HourlyForecast.dummy(),
        HourlyForecast.dummy(),
        HourlyForecast.dummy(),
        HourlyForecast.dummy(),
        HourlyForecast.dummy(),
        HourlyForecast.dummy(),
        HourlyForecast.dummy(),
        HourlyForecast.dummy(),
    ]
}

extension HourlyForecast {
    static func dummy(id: String = UUID().uuidString) -> HourlyForecast {
        .init(
            id: id,
            date: .now,
            wind: "11 km/h",
            uvIndex: "0",
            windGust: "34 km/h",
            pressure: "1015 mb",
            humidity: "86%",
            dewPoint: "26º",
            feelsLike: "31º",
            imageName: "cloud.sun.bolt.fill",
            condition: "Partly cloudy",
            cloudCover: "54%",
            visibility: "15 km",
            temperature: "28º",
            precipitationChance: "1%"
        )
    }
}
