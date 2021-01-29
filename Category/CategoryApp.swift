//
//  CategoryApp.swift
//  Category
//
//  Created by Dave Kondris on 29/01/21.
//

import SwiftUI

@main
struct CategoryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
