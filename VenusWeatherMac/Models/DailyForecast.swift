import WeatherKit
import Foundation

struct DailyForecast: Identifiable, Sendable {
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
}

extension Array where Element == DailyForecast {
    static let sample = [
        DailyForecast.dummy(),
        DailyForecast.dummy(),
        DailyForecast.dummy(),
        DailyForecast.dummy(),
        DailyForecast.dummy(),
        DailyForecast.dummy(),
        DailyForecast.dummy(),
        DailyForecast.dummy(),
        DailyForecast.dummy()
    ]
}

extension DailyForecast {
    static func dummy(id: String = UUID().uuidString) -> DailyForecast {
        .init(
            id: id,
            date: .now,
            imageName: "cloud.sun.fill",
            condition: "Partly cloudy",
            lowTemperature: "28.0º",
            highTempterature: "31.0º"
        )
    }
}
