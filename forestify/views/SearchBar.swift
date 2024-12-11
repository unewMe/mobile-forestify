//
//  SearchBar.swift
//  forestify
//
//  Created by on 09/12/2024.
//

import SwiftUI

struct SearchBar: View {
    @Binding var showSearchResults: Bool
    @Binding var noResultsFound: Bool
    @Binding var searchResults: [SearchResult]

    @State private var locationService = LocationService(completer: .init())
    @State private var search = ""

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search for a place", text: $search)
                .autocorrectionDisabled()
                .onSubmit {
                    Task {
                        let searchResults = (try? await locationService.search(with: search)) ?? []
                        DispatchQueue.main.async {
                            self.searchResults = searchResults
                            self.showSearchResults = true
                            self.noResultsFound = searchResults.isEmpty
                        }
                    }
                }
        }
        .padding()
        .frame(height: 47)
        .background(Color.white)
        .cornerRadius(21)
        .safeAreaInset(edge: .top) { Spacer().frame(height: 50) }
    }
}
