//
//  final_taskApp.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 9/9/25.
//

import SwiftUI

@main
struct final_taskApp: App {
    
    @MainActor private let repo = FavoritesRepositoryImpl()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView(repo: repo)
                .onAppear { OrientationLock.shared.mask = .portrait }
        }
    }
}
