import SwiftUI

struct MapButton: View {
    var id: String
    var name: String
    var filename: String
    var action: (String) async -> Void
    @Binding var selectedButtonID: String?
    @Binding var isLoading: Bool

    var body: some View {
        Button(action: {
            if selectedButtonID == id {
                selectedButtonID = nil
            } else {
                selectedButtonID = id
            }
            Task {
                await action(id)
            }
        }) {
            HStack(spacing: 11) {
                Image(filename)
                    .resizable()
                    .frame(width: 24, height: 24)

                Text(name)
                    .font(.custom("Inter", size: 15))
                    .foregroundColor(.black)
            }
            .padding(.leading, 11)
            .padding(.trailing, 11)
            .frame(height: 34)
            .background(Color.white)
            .cornerRadius(21)
            .overlay(
                RoundedRectangle(cornerRadius: 21)
                    .stroke(Color.black.opacity(selectedButtonID == id ? 1 : 0.5), lineWidth: 1)
            )
        }
    }
}
