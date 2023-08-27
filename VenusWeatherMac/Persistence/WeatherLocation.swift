import CoreData
import Foundation

@objc(WeatherLocation)
public class WeatherLocation: NSManagedObject {

}

extension WeatherLocation: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherLocation> {
        return NSFetchRequest<WeatherLocation>(entityName: "WeatherLocation")
    }

    @NSManaged public var identifier: String
    @NSManaged public var location: Data
    @NSManaged public var highTemperature: Data
    @NSManaged public var lowTemperature: Data
    @NSManaged public var currentTemperature: Data
    @NSManaged public var condition: String
    @NSManaged public var imageName: String
    @NSManaged public var isMainLocation: Bool
}

extension WeatherLocation {
    var venusLocation: VenusLocation? {
        guard let location = try? JSONDecoder()
            .decode(VenusLocation.self, from: location)
        else {
            return nil
        }
        return location
    }

    var currentTemperatureValue: Measurement<UnitTemperature>? {
        guard let currentTemperature = try? JSONDecoder()
            .decode(Measurement<UnitTemperature>.self, from: currentTemperature)
        else {
            return nil
        }
        return currentTemperature
    }

    var lowTemperatureValue: Measurement<UnitTemperature>? {
        guard let lowTemperature = try? JSONDecoder()
            .decode(Measurement<UnitTemperature>.self, from: lowTemperature)
        else {
            return nil
        }
        return lowTemperature
    }

    var highTemperatureValue: Measurement<UnitTemperature>? {
        guard let highTemperature = try? JSONDecoder()
            .decode(Measurement<UnitTemperature>.self, from: highTemperature)
        else {
            return nil
        }
        return highTemperature
    }

    var lowHighTemperature: String {
        guard let lowTemperatureValue, let highTemperatureValue else { return "" }
        return "L:"
        + format(temperature: lowTemperatureValue)
        + "  "
        + "H:"
        + format(temperature: highTemperatureValue)
    }
}
