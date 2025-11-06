//
//  FavoritesManager.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 25/9/25.
//

import Foundation

final class FavoritesManager: ObservableObject {
    
    @Published private(set) var items: [FavoriteCity] = []
    private let storageKey = "favorites.v1"
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }
    
    func isFavorite(id: String) -> Bool {
        items.contains { $0.id == id }
    }
    
    func toggle(_ f: FavoriteCity) {
        if let i = items.firstIndex(where: { $0.id == f.id }) {
            items.remove(at: i)
        } else {
            items.append(f)
        }
        save()
    }
    
    func remove(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }
    
    func mergeDetails(
        id: String,
        latitude: Double?,
        longitude: Double?,
        population: Int?,
        timezone: String?
    ) {
        guard let i = items.firstIndex(where: { $0.id == id }) else { return }
        var f = items[i]
        f.latitude = latitude ?? f.latitude
        f.longitude = longitude ?? f.longitude
        f.population = population ?? f.population
        f.timezone = timezone ?? f.timezone
        items[i] = f
        save()
    }
    
    private func load() {
        if let data = defaults.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([FavoriteCity].self, from: data) {
            self.items = decoded
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            defaults.set(data, forKey: storageKey)
        }
    }
}
