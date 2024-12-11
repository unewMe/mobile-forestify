import SwiftUI

struct InformationView: View {
    let area: String
    let amenities: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Powierzchnia: " + area)
                .padding(.bottom, 5)

            Divider()

            ForEach(amenities, id: \.self) { amenity in
                Text(amenity)
                    .padding(.vertical, 4)
                Divider()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}
