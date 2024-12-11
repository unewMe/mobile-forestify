import CoreLocation
import Foundation

struct APIResponse: Identifiable, Codable, Hashable {
    let id = UUID()
    let name: String
    let coordinates: [String]
    let category: String
    let pictures: [String]
    let link: String
    let map_type: String
    let waypoints: String

    var location: CLLocationCoordinate2D {
        guard coordinates.count == 2,
              let latitude = Double(coordinates[0]),
              let longitude = Double(coordinates[1])
        else {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    static func == (lhs: APIResponse, rhs: APIResponse) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
