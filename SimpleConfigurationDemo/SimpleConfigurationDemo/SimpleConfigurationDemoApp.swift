//
//  SimpleConfigurationDemoApp.swift
//  SimpleConfigurationDemo
//
//  Created by Travis Baksh on 5/22/23.
//

import SwiftUI

@main
struct SimpleConfigurationDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
