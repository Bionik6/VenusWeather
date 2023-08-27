import CoreData
import Foundation

@objc(WeatherLocation)
public class WeatherLocation: NSManagedObject {

}

extension WeatherLocation: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherLocation> {
        return NSFetchRequest<WeatherLocation>(entityName: "WeatherLocation")
    }

    @NSManaged public var location: Data
    @NSManaged public var highTemperature: Data
    @NSManaged public var lowTemperature: Data
    @NSManaged public var currentTemperature: Data
    @NSManaged public var condition: String
    @NSManaged public var imageName: String
    @NSManaged public var isMainLocation: Bool
}

extension WeatherLocation {
    var venusLocation: VenusLocation {
        guard let location = try? JSONDecoder()
            .decode(VenusLocation.self, from: location)
        else {
            fatalError("couldn't decode location")
        }
        return location
    }

    var currentTemperatureValue: Measurement<UnitTemperature> {
        guard let currentTemperature = try? JSONDecoder()
            .decode(Measurement<UnitTemperature>.self, from: currentTemperature)
        else {
            fatalError("couldn't decode current temperature")
        }
        return currentTemperature
    }

    var lowTemparatureValue: Measurement<UnitTemperature> {
        guard let lowTemperature = try? JSONDecoder()
            .decode(Measurement<UnitTemperature>.self, from: lowTemperature)
        else {
            fatalError("couldn't decode low temperature")
        }
        return lowTemperature
    }

    var highTemparatureValue: Measurement<UnitTemperature> {
        guard let highTemperature = try? JSONDecoder()
            .decode(Measurement<UnitTemperature>.self, from: highTemperature)
        else {
            fatalError("couldn't decode high temperature")
        }
        return highTemperature
    }

    var lowHighTemperature: String {
        "L:"
        + format(temperature: lowTemparatureValue)
        + "  "
        + "H:"
        + format(temperature: highTemparatureValue)
    }
}
