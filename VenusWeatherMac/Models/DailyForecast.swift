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

#if DEBUG
extension DailyForecast {

    static let dummy = DailyForecast(
        id: UUID().uuidString,
        date: .now,
        imageName: "cloud.sun.bolt.fill",
        condition: "Partly cloudy",
        lowTemperature: "28.0º",
        highTempterature: "31.0º"
    )
}
#endif
