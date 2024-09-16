//
//  CoreDataTestApp.swift
//  CoreDataTest
//
//  Created by Paulus Michael on 16/09/24.
//

import SwiftUI

@main
struct CoreDataTestApp: App {
   let persistenceController = PersistenceController.shared
   
   var body: some Scene {
      WindowGroup {
         ContentView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
      }
   }
}
