import SwiftUI

struct MapButtonList: View {
    @Binding var selectedButtonID: String?
    var searchForPlaces: (String) async -> Void
    @Binding var isLoading: Bool

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                MapButton(id: "s_parkingi", name: "Parkingi", filename: "s_parkingi", action: searchForPlaces, selectedButtonID: $selectedButtonID, isLoading: $isLoading)
                MapButton(id: "s_noclegi", name: "Noclegi", filename: "s_noclegi", action: searchForPlaces, selectedButtonID: $selectedButtonID, isLoading: $isLoading)
                MapButton(id: "s_biwaki", name: "Biwaki", filename: "s_biwaki", action: searchForPlaces, selectedButtonID: $selectedButtonID, isLoading: $isLoading)
                MapButton(id: "s_zanocuj", name: "Zanocuj w lesie", filename: "s_zanocuj", action: searchForPlaces, selectedButtonID: $selectedButtonID, isLoading: $isLoading)
                MapButton(id: "s_pieszo", name: "Pieszo", filename: "s_pieszo", action: searchForPlaces, selectedButtonID: $selectedButtonID, isLoading: $isLoading)
                MapButton(id: "s_rowerem", name: "Rowerem", filename: "s_rowerem", action: searchForPlaces, selectedButtonID: $selectedButtonID, isLoading: $isLoading)
                MapButton(id: "s_konno", name: "Konno", filename: "s_konno", action: searchForPlaces, selectedButtonID: $selectedButtonID, isLoading: $isLoading)
                MapButton(id: "s_edukacyjne", name: "Edukacyjne", filename: "s_edukacyjne", action: searchForPlaces, selectedButtonID: $selectedButtonID, isLoading: $isLoading)
                MapButton(id: "s_inne", name: "Inne", filename: "s_inne", action: searchForPlaces, selectedButtonID: $selectedButtonID, isLoading: $isLoading)
                MapButton(id: "s_wyprawy", name: "Wyprawy", filename: "s_wyprawy", action: searchForPlaces, selectedButtonID: $selectedButtonID, isLoading: $isLoading)
            }
            .padding(.vertical)
        }
        .background(Color.clear)
    }
}
