//
//  YouPlayApp.swift
//  YouPlay
//
//  Created by Диана Магомедова on 15.12.2024.
//

import SwiftUI

@main
struct YouPlayApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
