//
//  KnittingPatternCategory+CoreDataClass.swift
//  cs50-final-project
//
//  Created by Carter Riddall on 2022-06-29.
//
//

import Foundation
import CoreData

@objc(KnittingPatternCategory)
public class KnittingPatternCategory: NSManagedObject {
    
    public var patternArray: [KnittingPattern] {
        let patternSet = self.patterns as? Set<KnittingPattern> ?? []
        return patternSet.sorted {
            $0.name! < $1.name!
        }
    }
    
    public static func fetch(predicates: [NSPredicate]? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [KnittingPatternCategory] {
        let request = self.fetchRequest()
        if let predicates = predicates {
            let compoundPredicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: predicates)
            request.predicate = compoundPredicate
        }
        request.sortDescriptors = sortDescriptors
        if let patterns = try? DataController.context.fetch(request) {
            return patterns
        } else {
            return [KnittingPatternCategory]()
        }
    }
}

// Allows me to pass a single list of categories between all views
@MainActor class KnittingPatternCategories: ObservableObject {
    @Published var categories: [KnittingPatternCategory] = KnittingPatternCategory.fetch(sortDescriptors: [
        NSSortDescriptor(key: "name", ascending: true)
    ])
    // Initialized with all categories
    func refresh() {
        categories = KnittingPatternCategory.fetch(sortDescriptors: [
            NSSortDescriptor(key: "name", ascending: true)
        ])
    }
}
