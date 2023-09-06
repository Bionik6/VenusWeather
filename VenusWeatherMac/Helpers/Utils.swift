import Foundation

func format(temperature: Measurement<UnitTemperature>) -> String {
    let intValue = Int(temperature.value)
    switch temperature.unit {
    case .celsius:
        return "\(intValue)º"
    case .fahrenheit:
        return "\(intValue)F"
    case .kelvin:
        return "\(intValue)K"
    default:
        return ""
    }
}

func format(hour: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: hour)
}

func format(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EE d"
    if Calendar.current.isDateInToday(date) { return "Today" }
    return formatter.string(from: date)
}

func formatToPercent(value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    let number = NSNumber(value: value)
    return formatter.string(from: number) ?? ""
}

func format(pressure: Measurement<UnitPressure>) -> String {
    let intValue = Int(pressure.value)
    return "\(intValue) mb"
}
