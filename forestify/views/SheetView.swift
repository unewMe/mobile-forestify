import MapKit
import SwiftUI

struct SheetView: View {
    let annotationId: String
    let buttonId: String
    let apiResponse: APIResponse?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var annotation: AnnotationItem = .init(
        id: "1",
        name: "<Brak danych>",
        latitude: 0,
        longitude: 0,
        description: "<Brak danych>",
        images: [
            "https://example.com/images/forest1.jpg",
            "https://example.com/images/forest2.jpg",
        ],
        location: [
            "name": "<Brak danych>",
            "latitude": "<Brak danych>",
            "longitude": "<Brak danych>",
            "forest_office": "<Brak danych>",
        ],
        contact: [
            "phone": "<Brak danych>",
            "website": "<Brak danych>",
            "email": "<Brak danych>",
        ],
        area: "<Brak danych>",
        amenities: [],
        waypoints: []
    )
    @Binding var waypoints: [[Double]]
    @State private var currentDetent: PresentationDetent = .height(200)

    var body: some View {
        VStack {
            // Nagłówek
            HStack {
                if currentDetent == .large {
                    Button(action: {
                        withAnimation {
                            currentDetent = .height(200)
                        }
                    }) {
                        Image(systemName: "chevron.down")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
            }
            .padding()

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    Text(apiResponse?.name ?? "")
                        .font(.headline)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(AnnotationService().mapAnnotationID(id: buttonId))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    HStack {
                        Text("Otwarte")
                            .foregroundStyle(.green)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        Text("24/7")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }

                    Button(action: {
                        openMapsForDirections(latitude: annotation.latitude, longitude: annotation.longitude, placeName: apiResponse?.name ?? "")

                    }) {
                        HStack {
                            Image("nav")
                            Text("Trasa")
                        }
                        .font(.headline)
                        .frame(maxWidth: 100)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    .padding(.horizontal)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(annotation.images, id: \.self) { imageUrl in
                            AsyncImage(url: URL(string: imageUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 150, height: 100)
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .clipped()
                        }
                    }
                    .padding()
                }

                MyTabView(location: annotation.location, contacts: annotation.contact, area: annotation.area, amenities: annotation.amenities)
            }
        }
        .interactiveDismissDisabled()
        .presentationDetents([.height(200), .large], selection: $currentDetent)
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
        .onAppear {
            loadAnnotation()
        }
    }

    private func loadAnnotation() {
        Task {
            do {
                let id = apiResponse?.link.split(separator: "id_obiekt=").last
                guard let ID = id else {
                    fatalError("PRZYPAŁ")
                }
                print("ID: " + String(ID))

                let fetchAnnotation = try await AnnotationService().fetchAnnotation(by: String(ID))
                print("GOT RESPONSE")
                print(fetchAnnotation)
                DispatchQueue.main.async {
                    self.annotation = fetchAnnotation
                    self.waypoints = annotation.waypoints
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
            DispatchQueue.main.async { self.isLoading = false
            }
        }
    }

    func openMapsForDirections(latitude: CLLocationDegrees, longitude: CLLocationDegrees, placeName: String) {
        let destinationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let placemark = MKPlacemark(coordinate: destinationCoordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = placeName

        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
        ]

        mapItem.openInMaps(launchOptions: launchOptions)
    }
}
