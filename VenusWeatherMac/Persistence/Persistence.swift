import CoreData
import WeatherKit

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "VenusWeather")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension PersistenceController {
    @discardableResult
    func save(
        weather: DayWeather,
        location: VenusLocation,
        currentWeather: CurrentWeather
    ) -> WeatherLocation? {
        guard let venusLocation = location.data else {
            fatalError("location couldn't be resolved")
        }
        do {
            var weatherLocation: WeatherLocation

            if let wl = findWeatherLocation(from: location) {
                weatherLocation = wl
            } else {
                weatherLocation = WeatherLocation(context: container.viewContext)
                weatherLocation.identifier = location.id
                weatherLocation.location = venusLocation
            }

            weatherLocation.imageName = weather.symbolName
            weatherLocation.condition = weather.condition.description
            weatherLocation.lowTemperature = try JSONEncoder().encode(weather.lowTemperature)
            weatherLocation.highTemperature = try JSONEncoder().encode(weather.highTemperature)
            weatherLocation.currentTemperature = try JSONEncoder().encode(currentWeather.temperature)

            try container.viewContext.save()
            return weatherLocation
        } catch {
            print("failed to saved/update location")
            return nil
        }
    }

    func getAllLocations() -> [FavoriteLocation] {
        let fetchRequest: NSFetchRequest<WeatherLocation> = WeatherLocation.fetchRequest()
        do {
            return try container.viewContext.fetch(fetchRequest).map {
                FavoriteLocation.init(weatherLocation: $0)
            }
        } catch {
            print("Failed to fetch weather locations: \(error)")
            return []
        }
    }

    func deleteWeatherLocation(_ location: VenusLocation) -> Bool {
        let fetchRequest: NSFetchRequest<WeatherLocation> = WeatherLocation.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(WeatherLocation.identifier),
            location.id
        )
        do {
            let object = try container.viewContext.fetch(fetchRequest).first
            guard let object else { return false }
            container.viewContext.delete(object)
            try container.viewContext.save()
            return true
        } catch {
            print("Failed to delete object: \(error)")
            return false
        }
    }

    func findWeatherLocation(from location: VenusLocation) -> WeatherLocation? {
        let fetchRequest: NSFetchRequest<WeatherLocation> = WeatherLocation.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(WeatherLocation.identifier),
            location.id
        )
        do {
            let weatherLocation = try container.viewContext.fetch(fetchRequest).first
            guard let weatherLocation else { return nil }
            return weatherLocation
        } catch {
            print("Failed to find object: \(error)")
            return nil
        }
    }
}
