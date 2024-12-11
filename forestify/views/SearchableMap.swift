import CoreLocation
import MapKit
import SwiftUI

struct SearchableMap: View {
    @State private var position = MapCameraPosition.automatic
    @State private var selectedLocation: SearchResult?
    @State private var showSearchResults = false
    @State private var noResultsFound = false
    @State private var searchResults = [SearchResult]()
    @State private var locationManager = CLLocationManager()
    @State private var selectedButtonID: String? = nil
    @State private var apiResponses: [APIResponse] = []
    @State private var selectedMarkerID: UUID?
    @State private var isSheetPresented: Bool = false
    @State private var isLoading = false
    private var selectedMarker: APIResponse? {
        apiResponses.first { $0.id == selectedMarkerID }
    }

    private var service = AnnotationService()
    @State private var waypoints: [[Double]] = []
    private var mappedWaypoints: [CLLocationCoordinate2D] {
        waypoints.map { CLLocationCoordinate2D(latitude: $0[0], longitude: $0[1]) }
    }

    var body: some View {
        ZStack {
            Map(position: $position, selection: $selectedMarkerID) {
                ForEach(apiResponses) { result in
                    Annotation(service.mapAnnotationID(id: selectedButtonID ?? ""), coordinate: result.location) {
                        Image(selectedMarkerID != result.id ? (selectedButtonID.map { $0 + "_pin" }) ?? "" : "Parking3")
                            .resizable()
                            .scaleEffect(selectedMarkerID == result.id ? 1.5 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: selectedMarkerID)
                    }
                    .tag(result.id)
                    .tint(Color.black)
                }

                if !mappedWaypoints.isEmpty {
                    MapPolyline(coordinates: mappedWaypoints)
                        .stroke(Color.red, lineWidth: 3)
                }
            }
            .ignoresSafeArea()
            .onChange(of: selectedMarkerID) {
                isSheetPresented = selectedMarkerID != nil
                if !isSheetPresented {
                    waypoints = []
                } else {
                    position = MapCameraPosition.region(MKCoordinateRegion(
                        center: selectedMarker?.location ?? CLLocationCoordinate2D(latitude: 25, longitude: 25),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    ))
                }
            }
            .onChange(of: selectedButtonID) {
                waypoints = []
                isSheetPresented = false
                apiResponses = []
            }
            .sheet(isPresented: $isSheetPresented) {
                if let marker = selectedMarker {
                    SheetView(annotationId: "123", buttonId: selectedButtonID ?? "", apiResponse: selectedMarker, waypoints: $waypoints).id(selectedMarkerID)
                } else {
                    Text("Nie znaleziono szczegółów dla zaznaczonego markera")
                }
            }

            VStack {
                SearchBar(showSearchResults: $showSearchResults, noResultsFound: $noResultsFound, searchResults: $searchResults)

                MapButtonList(selectedButtonID: $selectedButtonID, searchForPlaces: searchForPlaces, isLoading: $isLoading)

                Spacer()

                Footer(centerMapOnCurrentLocation: centerMapOnCurrentLocation)
            }
            .padding()

            if showSearchResults {
                SearchResults(showSearchResults: $showSearchResults, noResultsFound: noResultsFound, searchResults: searchResults, selectedLocation: $selectedLocation, position: $position)
            }

            if apiResponses.isEmpty && selectedButtonID != nil {
                ZStack {
                    // Dimmed background
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()

                    VStack {
                        LoadingView()
                            .frame(width: 200, height: 200)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(15)
                            .shadow(radius: 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .transition(.opacity)
                .animation(.easeInOut, value: apiResponses.isEmpty)
            }
        }
        .disabled(isLoading)
    }

    func centerMapOnCurrentLocation() {
        locationManager.requestWhenInUseAuthorization()
        if let location = locationManager.location {
            let coordinate = location.coordinate
            position = .region(MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
        } else {
            print("Nie udało się uzyskać bieżącej lokalizacji")
        }
    }

    func searchForPlaces(id: String) async {
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 53.8176796, longitude: 18.356781),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        let latitude = region.center.latitude
        let longitude = region.center.longitude
        let zoom = Int(log2(360 * (UIScreen.main.bounds.width / 256) / region.span.longitudeDelta))

        print(zoom)
        print(latitude)
        print(longitude)

        let urlString = "https://czaswlas.pl/_ajax/get_map_locations.php"
        guard let url = URL(string: urlString) else {
            print("Nieprawidłowy URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json, text/javascript, */*; q=0.01", forHTTPHeaderField: "Accept")
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")

        let bodyString = "search=1&\(id)=1&s_nazwa=&m_zoom=\(zoom)&m_lat=\(latitude)&m_lng=\(longitude)"
        request.httpBody = bodyString.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Błąd podczas pobierania danych: \(error)")
                return
            }
            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                var results = try decoder.decode([APIResponse].self, from: data)

                if results.count > 1000 {
                    results.shuffle()
                    results = Array(results.prefix(1000))
                }

                apiResponses = results

            } catch {
                print("Błąd podczas dekodowania danych: \(error)")
            }
        }
        task.resume()
    }
}
