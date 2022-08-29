//
//  KnittingPattern+CoreDataClass.swift
//  cs50-final-project
//
//  Created by Carter Riddall on 2022-06-29.
//
//

import Foundation
import CoreData
import UIKit

@objc(KnittingPattern)
public class KnittingPattern: NSManagedObject {
    
    public static func fetch(predicates: [NSPredicate]? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [KnittingPattern] {
        let request = self.fetchRequest()
        if let predicates = predicates {
            let compoundPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: predicates)
            request.predicate = compoundPredicate
        }
        request.sortDescriptors = sortDescriptors
        if let patterns = try? DataController.context.fetch(request) {
            return patterns
        } else {
            return [KnittingPattern]()
        }
    }
    
    public static func checkURL(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
}

@MainActor class KnittingPatterns: ObservableObject {
    @Published var patterns: [KnittingPattern]
    init() {
        patterns = KnittingPattern.fetch(sortDescriptors: [
            NSSortDescriptor(key: "name", ascending: true)
        ])
    }
    func reloadPatterns(_ selectedCategories: Set<UUID>? = nil) {
        if let selectedCategories = selectedCategories {
            var categories = [KnittingPatternCategory]()
            for categoryId in selectedCategories {
                let category = KnittingPatternCategory.fetch(predicates: [NSPredicate(format: "id == %@", categoryId as CVarArg)])[0]
                categories.append(category)
            }
            self.patterns.removeAll()
            for category in categories {
                self.patterns.append(contentsOf: category.patternArray)
            }
        } else {
            patterns = KnittingPattern.fetch(sortDescriptors: [
                NSSortDescriptor(key: "name", ascending: true)
            ])
        }
    }
}
