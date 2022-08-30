//
//  AddCategoryView.swift
//  cs50-final-project
//
//  Created by Carter Riddall on 2022-07-20.
//

import SwiftUI

struct AddCategoryView: View {
    @State var addCategoryShown = true
    @State var categoryName = ""
    var body: some View {
        NeedToFixView()
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView()
    }
}
