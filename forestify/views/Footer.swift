import SwiftUI

struct Footer: View {
    var centerMapOnCurrentLocation: () -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image("Logo")
                    .frame(height: 44)
                    .padding(.leading, 4)
                Spacer()
                Button(action: centerMapOnCurrentLocation) {
                    ZStack {
                        Color.clear
                        Image("currloc")
                    }
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                }
                .padding()
            }
            .padding(.bottom, 16)
        }
        .ignoresSafeArea()
    }
}
