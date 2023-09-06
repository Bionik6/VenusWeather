import CoreData
import Foundation


struct FavoriteLocation: Equatable, Identifiable {
    let identifier: String
    let location: VenusLocation?
    let highTemperature: Measurement<UnitTemperature>?
    let lowTemperature: Measurement<UnitTemperature>?
    let currentTemperature: Measurement<UnitTemperature>?
    let condition: String
    let imageName: String
    let isMainLocation: Bool

    init(weatherLocation: WeatherLocation) {
        self.identifier = weatherLocation.identifier
        self.location = weatherLocation.venusLocation
        self.highTemperature = weatherLocation.highTemperatureValue
        self.lowTemperature = weatherLocation.lowTemperatureValue
        self.currentTemperature = weatherLocation.currentTemperatureValue
        self.condition = weatherLocation.condition
        self.imageName = weatherLocation.imageName
        self.isMainLocation = weatherLocation.isMainLocation
    }

    var id: String { identifier }

    var lowHighTemperature: String {
        guard let lowTemperature, let highTemperature else { return "" }
        return "L:"
        + format(temperature: lowTemperature)
        + "  "
        + "H:"
        + format(temperature: highTemperature)
    }
}


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


