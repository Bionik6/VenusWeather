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
    func save(
        weather: DayWeather,
        location: VenusLocation,
        currentWeather: CurrentWeather
    ) {
        guard let location = location.data else {
            fatalError("location couldn't be resolved")
        }
        do {
            let weatherLocation = WeatherLocation(context: container.viewContext)
            weatherLocation.location = location
            weatherLocation.imageName = weather.symbolName
            weatherLocation.condition = weather.condition.description
            weatherLocation.lowTemperature = try JSONEncoder().encode(weather.lowTemperature)
            weatherLocation.highTemperature = try JSONEncoder().encode(weather.highTemperature)
            weatherLocation.currentTemperature = try JSONEncoder().encode(currentWeather.temperature)

            try container.viewContext.save()
        } catch {
            print("failed to saved location")
        }
    }

    func getAllLocations() -> [WeatherLocation] {
        let fetchRequest: NSFetchRequest<WeatherLocation> = WeatherLocation.fetchRequest()
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch weather locations: \(error)")
            return []
        }
    }

    func deleteWeatherLocation(_ location: WeatherLocation) {
        container.viewContext.delete(location)
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
