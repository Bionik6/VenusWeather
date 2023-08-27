import Foundation
import CoreLocation

struct VenusLocation: Identifiable, Sendable, Equatable, Codable {
    let latitude: Double
    let longitute: Double
    let city: String?
    let country: String?

    public init(
        latitude: Double,
        longitute: Double,
        city: String?,
        country: String?
    ) {
        self.latitude = latitude
        self.longitute = longitute
        self.city = city
        self.country = country
    }

    var fullName: String {
        guard let city, let country else {
            return city ?? country ?? "---"
        }
        return "\(city), \(country)"
    }

    var data: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }

    var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitute)
    }

    var id: String {
        "\(latitude):\(longitute)"
    }
}
