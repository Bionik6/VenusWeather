import CoreData
import Foundation

@objc(WeatherLocation)
public class WeatherLocation: NSManagedObject {

}

extension WeatherLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherLocation> {
        return NSFetchRequest<WeatherLocation>(entityName: "WeatherLocation")
    }

    @NSManaged public var location: Data?
    @NSManaged public var highTemperature: Double
    @NSManaged public var lowTemperature: Double
    @NSManaged public var temperatureUnit: String?
    @NSManaged public var currentTemperature: Double
    @NSManaged public var condition: String?
    @NSManaged public var isMainLocation: Bool
}

extension WeatherLocation : Identifiable {

}
