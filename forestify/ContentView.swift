//
//  ContentView.swift
//  forestify
//
//  Created by stud on 05/11/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SearchableMap()
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
