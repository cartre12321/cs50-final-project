//
//  ContentView.swift
//  cs50-final-project
//
//  Created by Carter Riddall on 2022-06-29.
//

import SwiftUI

struct ContentView: View {
    
    // Grab Managed Object Context
    @Environment(\.managedObjectContext) var context
    // Get all patterns and categories
    @StateObject var patterns = KnittingPatterns()
    @StateObject var categories = KnittingPatternCategories()
    // Category filter controls
    @State private var showingCategories = false
    @State var selectedCategories = Set<UUID>()
    // Edit pattern view control
    @State var editPatternViewShown = false
    
    // Set grid width to 3 items
    var items: [GridItem] {
        Array(repeating: .init(.adaptive(minimum: 120)), count: 3)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                // Create grid using 'items' variable from above
                LazyVGrid(columns: items, content: {
                    // Add PatternListItem for every pattern loaded
                    ForEach(patterns.patterns, id: \.id) { pattern in
                        NavigationLink {
                            PatternDetailView(viewModel: PatternDetailViewModel(pattern, mode: .view), fileLink: pattern.file!.absoluteString, selectedCategory: pattern.category!)
                        } label: {
                            PatternListItem(pattern: pattern)
                        }
                        // Add context menu to each pattern so that you can edit and delete them
                            .contextMenu {
                                Button {
                                    editPatternViewShown.toggle()
                                } label: {
                                    HStack {
                                        Image(systemName: K.edit)
                                        Spacer()
                                        Text("Edit")
                                    }
                                }
                                
                                Button(role: .destructive) {
                                    DataController.delete(pattern)
                                    patterns.reloadPatterns()
                                } label: {
                                    HStack {
                                        Image(systemName: K.trash)
                                        Spacer()
                                        Text("Delete")
                                    }
                                }
                            }
                            .padding()
                            .sheet(isPresented: $editPatternViewShown) {

                                PatternDetailView(viewModel: PatternDetailViewModel(pattern, mode: .edit), fileLink: pattern.file!.absoluteString, selectedCategory: pattern.category!)
                                    .environmentObject(patterns)
                                    .environmentObject(categories)
                            }
                    }
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            showingCategories = true
                        } label: {
                            Text("Categories")
                        }

                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            AddPatternView()
                                .environmentObject(categories)
                                .environmentObject(patterns)
                        } label: {
                            Image(systemName: K.plus)
                        }
                    }
                }
                .navigationTitle("Pattern List")
                .sheet(isPresented: $showingCategories, onDismiss: {
                    patterns.reloadPatterns(selectedCategories)
                }, content: {
                    CategoryFilterView(selectedItems: $selectedCategories)
                        .environmentObject(patterns)
                        .environmentObject(categories)
                })
                .onAppear {
                    categories.refresh()
                    for category in categories.categories {
                        selectedCategories.insert(category.id!)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
