//
//  cs50_final_projectApp.swift
//  cs50-final-project
//
//  Created by Carter Riddall on 2022-06-29.
//

import SwiftUI
import CoreData

// Create AppDelegate to load defaults into Core Data on first launch
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        preloadData()
        return true
    }
}

private func preloadData() {
    let preloadedDataKey = "didPreloadData"
    
    let userDefaults = UserDefaults.standard
    
    if !userDefaults.bool(forKey: preloadedDataKey) {
        // Get URL for 'PreloadedData' property list
        guard let urlPath = (Bundle.main.url(forResource: "PreloadedData", withExtension: "plist")) else {
            return
        }
        if let categoryNames = NSArray(contentsOf: urlPath) as? [String] {
            for categoryName in categoryNames {
                let newCategory = KnittingPatternCategory(context: DataController.context)
                newCategory.name = categoryName
                newCategory.id = UUID()
                if DataController.save() {
                    print("Saved")
                }
            }
        }
        // Set 'didPreloadData' to true so the app doesn't load any duplicate copies
        userDefaults.set(true, forKey: preloadedDataKey)
    }
}

@main
struct cs50_final_projectApp: App {
    // inject AppDelegate into SwiftUI lifecycle to preload the default data if needed
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, DataController.context)
        }
    }
}
