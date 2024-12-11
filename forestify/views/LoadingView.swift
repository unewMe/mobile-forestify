import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ZStack {
                Image("leaf")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white)
            }
            .padding(.bottom, 20)

            Text("Ładowanie danych...")
                .font(.headline)
                .foregroundColor(.black)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
    }
}
