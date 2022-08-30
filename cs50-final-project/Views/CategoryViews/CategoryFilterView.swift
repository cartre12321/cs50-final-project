//
//  CategoryFilterView.swift
//  cs50-final-project
//
//  Created by Carter Riddall on 2022-06-29.
//

import SwiftUI

struct CategoryFilterView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var patterns: KnittingPatterns
    @EnvironmentObject var categories: KnittingPatternCategories
    @Binding var selectedItems: Set<UUID>
    @State var addCategoryShown = false
    @State var categoryName = ""
    
    var body: some View {
        NavigationView {
            List() {
                ForEach(categories.categories) { category in
                   CategoryListRow(category: category, selectedItems: $selectedItems)
                }
                .onDelete { indexSet in
                    guard indexSet.count == 1 else {
                        print("Unknown error")
                        return
                    }
                    print(indexSet.first!)
                    for pattern in categories.categories[indexSet.first!].patternArray {
                        pattern.category = categories.categories.first(where: { category in category.name == "Other" })
                    }
                    context.delete(categories.categories[indexSet.first!])
                    if DataController.save() {
                        categories.refresh()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .foregroundColor(.accentColor)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addCategoryShown.toggle()
//                        AddCategoryView()
//                            .environmentObject(categories)
                    } label: {
                        Image(systemName: K.plus)
                    }

                }
            }
            .navigationBarTitle("Categories")
            .alert(Text("Add New Category"), isPresented: $addCategoryShown) {
                Button("Save") {
                    let category = KnittingPatternCategory(context: context)
                    category.name = categoryName
                    category.id = UUID()
                    if DataController.save() {
                        categories.refresh()
                    }
                }
                TextField("Category Name", text: $categoryName)
            } message: {
                VStack {
                    Text("Message")
//                    TextField("Category Name", text: $categoryName)
                }
            }
        }
    }
}

struct CategoryFilterView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryFilterView(selectedItems: .constant([UUID()]))
            .environmentObject(KnittingPatterns())
            .environmentObject(KnittingPatternCategories())
    }
}
