//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by Hasan Saral on 11.03.2025.
//

import SwiftUI

@main
struct TaskManagerApp: App {
    let provider: CoreDataProvider
    @AppStorage("appTheme") private var isDarkModeOn = false
    @AppStorage("colorkey") var storedColor: Color = .accentColor

    init() {
        provider = CoreDataProvider()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(menuOpened: false)
                .preferredColorScheme(isDarkModeOn ? .dark : .light)
                .accentColor(storedColor)
        }
        .environment(\.managedObjectContext, provider.context)
    }
}
