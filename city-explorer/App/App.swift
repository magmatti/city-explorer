//
//  final_taskApp.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 9/9/25.
//

import SwiftUI

@main
struct final_taskApp: App {
    
    @StateObject private var favorites = FavoritesManager()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(favorites)
                .onAppear { OrientationLock.shared.mask = .portrait }
        }
    }
}
