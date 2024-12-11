import SwiftUI

struct ContactView: View {
    let contacts: [String: String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image("phone")
                Text(contacts["phone"] ?? "Brak danych")
            }

            Divider()

            HStack {
                Image("phone")
                Link(contacts["website"] ?? "", destination: URL(string: contacts["website"] ?? "")!)
            }

            Divider()

            HStack {
                Image("phone")
                Text(contacts["email"] ?? "Brak danych")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}
