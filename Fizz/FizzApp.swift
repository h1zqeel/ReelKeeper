//
//  FizzApp.swift
//  Fizz
//
//  Created by Hizqeel Javed on 02/01/2023.
//

import SwiftUI

@main
struct FizzApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
