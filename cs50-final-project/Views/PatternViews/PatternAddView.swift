//
//  PatternAddView.swift
//  cs50-final-project
//
//  Created by Carter Riddall on 2022-08-08.
//

import SwiftUI

struct PatternAddView: View {
    
    @State private var patternName = ""
    @State private var urlString = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Pattern Name", text: $patternName)
                TextField("File Link", text: $urlString)
            }
            .navigationTitle("New Pattern")
        }
    }
}

struct PatternAddView_Previews: PreviewProvider {
    static var previews: some View {
        PatternAddView()
    }
}
