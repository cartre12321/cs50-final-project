//
//  PatternListItem.swift
//  cs50-final-project
//
//  Created by Carter Riddall on 2022-06-29.
//

import SwiftUI

struct PatternListItem: View {
    
    @State var pattern: KnittingPattern
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack {
            if let previewImage = pattern.previewImage {
                Image(uiImage: UIImage(data: previewImage)!)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: K.defaultPreviewImage)
                    .resizable()
                    .scaledToFit()
            }
            Text(pattern.name!)
                .foregroundColor(.primary)
            Text(pattern.category!.name!)
        }
    }
}

//struct PatternListItem_Previews: PreviewProvider {
//    static var previews: some View {
//        PatternListItem(pattern: KnittingPattern.fetch()[0])
//    }
//}
