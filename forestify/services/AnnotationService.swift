import Foundation

import Foundation

struct AnnotationItem: Decodable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let description: String
    let images: [String]
    let location: [String: String]
    let contact: [String: String]
    let area: String
    let amenities: [String]
    let waypoints: [[Double]]
}

enum AnnotationServiceError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}

class AnnotationService {
    private let baseURL = "http://88.198.164.165:3000/items/"

    func fetchAnnotation(by id: String) async throws -> AnnotationItem {
        guard let url = URL(string: "\(baseURL)\(id)") else {
            throw AnnotationServiceError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw AnnotationServiceError.requestFailed
        }

        do {
            let decodedItem = try JSONDecoder().decode(AnnotationItem.self, from: data)
            print(decodedItem)
            return decodedItem
        } catch {
            throw AnnotationServiceError.decodingFailed
        }
    }

    func mapAnnotationID(id: String) -> String {
        switch id {
        case "s_parkingi":
            return "Parking"
        case "s_noclegi":
            return "Nocleg"
        case "s_biwaki":
            return "Biwak"
        case "s_zanocuj":
            return "Zanocuj w lesie"
        case "s_pieszo":
            return "Pieszo"
        case "s_rowerem":
            return "Rowerem"
        case "s_konno":
            return "Konno"
        case "s_edukacyjne":
            return "Edukacyjne"
        case "s_inne":
            return "Inne"
        case "s_wyprawy":
            return "Wyprawa"
        default:
            return "Nieznany typ"
        }
    }
}
