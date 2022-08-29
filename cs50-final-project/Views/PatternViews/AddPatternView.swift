//
//  AddPatternView.swift
//  cs50-final-project
//
//  Created by Carter Riddall on 2022-06-29.
//

import SwiftUI
import struct SwiftUIX.ImagePicker
import class SwiftUIX.Keyboard

struct AddPatternView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var categories: KnittingPatternCategories
    @EnvironmentObject var patterns: KnittingPatterns
    @State var patternName: String = ""
    @State var fileLink: String = ""
    @State var categoryPickerShown = false
    @State var selectedCategory: KnittingPatternCategory = KnittingPatternCategory.fetch().first { category in
        category.name! == "Other"
    }!
    @State var imagePickerShown = false
    @State var selectedImage: Data? = nil
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Text("Pattern Name")
                        .font(.title)
                    TextField("Pattern Name", text: $patternName)
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
                .popover(isPresented: $categoryPickerShown) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories.categories) { category in
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
        }
        .onTapGesture {
            Keyboard.dismiss()
        }
        .toolbar {
            Button {
                if patternName != "", KnittingPattern.checkURL(urlString: fileLink) {
                    let newPattern = KnittingPattern(context: context)
                    newPattern.name = patternName
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
        .navigationTitle("Add Pattern")
    }
}


struct AddPatternView_Previews: PreviewProvider {
    static var previews: some View {
        AddPatternView()
            .environmentObject(KnittingPatternCategories())
    }
}
