//
//  EditPatternView.swift
//  cs50-final-project
//
//  Created by Carter Riddall on 2022-07-20.
//

import SwiftUI
import struct SwiftUIX.ImagePicker

enum DetailViewMode {
    case view
    case edit
}

struct PatternDetailView: View {
    
    @StateObject var viewModel: PatternDetailViewModel
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var categories: KnittingPatternCategories
    @EnvironmentObject var patterns: KnittingPatterns
    @State var fileLink: String
    @State var categoryPickerShown = false
    @State var selectedCategory: KnittingPatternCategory
    @State var imagePickerShown = false
    @State var selectedImage: Data?
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Text("Pattern Name")
                        .font(.title)
                    TextField("Pattern Name", text: $viewModel.pattern.name)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.words)
                }
                    .padding()
                VStack {
                    Text("Link to File")
                        .font(.title)
                    TextField("Link to File", text: $fileLink)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.none)
                }
                    .padding()
                VStack {
                    Text("Category")
                        .font(.title)
                    Button {
                        categoryPickerShown.toggle()
                    } label: {
                        Text(selectedCategory.name!)
                            .font(.title2)
                    }
                }
                .padding()
                .sheet(isPresented: $categoryPickerShown) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories.categories, id: \.id) { category in
                            Text(category.name!).tag(category as KnittingPatternCategory)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                VStack {
                    Text("Image")
                        .font(.title)
                    Button {
                        imagePickerShown.toggle()
                    } label: {
                        if let selectedImage = selectedImage {
                            Image(uiImage: UIImage(data: selectedImage)!)
                                .resizable()
                                .scaledToFit()
                                .padding()
                        } else {
                            Image(systemName: K.defaultPreviewImage)
                                .resizable()
                                .scaledToFit()
                                .padding()
                        }
                    }
                }
                .padding()
                .fullScreenCover(isPresented: $imagePickerShown) {
                    ImagePicker(data: $selectedImage, encoding: .png)
                }
            }
                .toolbar {
                    Button {
                        if viewModel.pattern.name! != "", KnittingPattern.checkURL(urlString: fileLink) {
                            let newPattern = KnittingPattern(context: context)
                            newPattern.name = viewModel.pattern.name!
                            newPattern.previewImage = selectedImage
                            newPattern.file = URL(string: fileLink)!
                            newPattern.category = selectedCategory
                            newPattern.id = UUID()
                            if DataController.save() {
                                patterns.reloadPatterns()
                                dismiss()
                            } else {
                                print("Couldn't save")
                            }
                        } else {
                            
                        }
                    } label: {
                        Text("Save")
                    }
                }
                .navigationTitle("Edit Pattern")
        }
    }
}

//struct EditPatternView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditPatternView()
//    }
//}
