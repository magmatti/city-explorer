//
//  ContentView.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 9/9/25.
//

import SwiftUI

struct RootView: View {
    
    enum Tab: Hashable { case home, favorites, profile }
    
    @State private var selection: Tab = .home
    @State private var homePath = NavigationPath()
    @State private var favoritesPath = NavigationPath()
    @State private var profilePath = NavigationPath()
    
    let repo: FavoritesRepository
    
    var body: some View {
        TabView(selection: $selection) {
            
            // HOME
            NavigationStack(path: $homePath) {
                CountriesView(repo: repo)
                    .navigationTitle("Home")
                    .toolbarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Home", systemImage: "house") }
            .tag(Tab.home)
            
            // FAVORITES
            NavigationStack(path: $favoritesPath) {
                FavoritesView(repo: repo)
                    .navigationTitle("Favorites")
                    .toolbarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Favorites", systemImage: "star") }
            .tag(Tab.favorites)
            
            // PROFILE
            NavigationStack(path: $profilePath) {
                ProfileView()
                    .navigationTitle("Profile")
                    .toolbarTitleDisplayMode(.inline)
                    .allowsLandscape()
            }
            .tabItem { Label("Profile", systemImage: "person") }
            .tag(Tab.profile)
        }
    }
}

#Preview {
    RootView(repo: FavoritesRepoPreviewMock())
}
