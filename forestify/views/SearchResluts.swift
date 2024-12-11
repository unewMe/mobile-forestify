import MapKit
import SwiftUI

struct SearchResults: View {
    @Binding var showSearchResults: Bool
    var noResultsFound: Bool
    var searchResults: [SearchResult]
    @Binding var selectedLocation: SearchResult?
    @Binding var position: MapCameraPosition

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showSearchResults = false
                }) {
                    Image(systemName: "chevron.down")
                        .padding()
                        .foregroundColor(.black)
                }
                .padding(.leading, 10)
                Spacer()
            }
            .padding(.top, 40)

            if noResultsFound {
                Spacer()
                Text("Brak wyników wyszukiwania")
                    .foregroundColor(.red)
                    .font(.headline)
                    .padding()
                Spacer()
            } else {
                List(searchResults, id: \.id) { result in
                    Button(action: {
                        selectedLocation = result
                        position = .region(MKCoordinateRegion(
                            center: result.location,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        ))
                        showSearchResults = false
                    }) {
                        HStack {
                            Image("location_image")

                            VStack(alignment: .leading) {
                                Text(result.title)
                                    .font(.headline)
                                Text(result.subTitle)
                                    .font(.subheadline)
                            }

                            Spacer()

                            Image("chevron_up_left")
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
    }
}
