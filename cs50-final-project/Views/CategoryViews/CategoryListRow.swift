//
//  CategoryListRow.swift
//  cs50-final-project
//
//  Created by Carter Riddall on 2022-07-19.
//

import SwiftUI

struct CategoryListRow: View {
    var category: KnittingPatternCategory
    @Binding var selectedItems: Set<UUID>
    
    var isSelected: Bool {
        selectedItems.contains(category.id!)
    }
    var body: some View {
        HStack {
            Text(category.name!)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
            }
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture {
            if isSelected {
                self.selectedItems.remove(category.id!)
            } else {
                self.selectedItems.insert(category.id!)
            }
        }
    }
}

struct CategoryListRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListRow(category: KnittingPatternCategories().categories[0], selectedItems: .constant([UUID()]))
    }
}
