import SwiftUI

struct AboutView: View {
    let locations: [String: String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image("name")
                Text(locations["name"] ?? "Brak danych")
            }

            Divider()

            HStack {
                Image("compas")

                VStack {
                    Text(locations["latitude"] ?? "Brak danych")

                    Text(locations["longitude"] ?? "Brak danych")
                }
            }

            Divider()

            HStack {
                Image("axe")
                Text(locations["forest_office"] ?? "Brak danych")
            }

            Divider()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}
