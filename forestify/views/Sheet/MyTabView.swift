import SwiftUI

struct MyTabView: View {
    let location: [String: String]
    let contacts: [String: String]
    let area: String
    let amenities: [String]

    @State private var selectedTab = 0

    var body: some View {
        VStack {
            Picker("", selection: $selectedTab) {
                Text("O obiekcie").tag(0)
                Text("Kontakt").tag(1)
                Text("Informacje").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if selectedTab == 0 {
                AboutView(locations: location)

            } else if selectedTab == 1 {
                ContactView(contacts: contacts)

            } else if selectedTab == 2 {
                InformationView(area: area, amenities: amenities)
            }
        }
    }
}
