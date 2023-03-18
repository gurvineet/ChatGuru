//
//  ChatGuruApp.swift
//  ChatGuru
//
//  Created by Gurvineet Dhillon on 3/18/23.
//

import SwiftUI

@main
struct ChatGuruApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
