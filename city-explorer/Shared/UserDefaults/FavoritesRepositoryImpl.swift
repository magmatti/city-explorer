//
//  FavoritesRepositoryImpl.swift
//  city-explorer
//
//  Created by Mateusz Wójtowicz on 6/11/25.
//

import Foundation
import Combine

@MainActor
final class FavoritesRepositoryImpl: FavoritesRepository {
    
    @Published private var storage: [FavoriteCity] = []
    var items: [FavoriteCity] { storage }
    var itemsPublisher: AnyPublisher<[FavoriteCity], Never> { $storage.eraseToAnyPublisher() }
    
    private let defaults: UserDefaults
    private let key = "favorites.v1"
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: key),
           let decoded = try? JSONDecoder().decode([FavoriteCity].self, from: data) {
            storage = decoded
        }
    }
    
    func isFavorite(id: String) -> Bool {
        storage.contains { $0.id == id }
    }
    
    func toggle(_ f: FavoriteCity) {
        if let i = storage.firstIndex(where: { $0.id == f.id}) {
            storage.remove(at: i)
        } else {
            storage.append(f)
        }
        persist()
    }
    
    func remove(at offsets: IndexSet) {
        storage.remove(atOffsets: offsets)
        persist()
    }
    
    func mergeDetails(
        id: String,
        latitude: Double?, longitude: Double?,
        population: Int?, timezone: String?
    ) {
        guard let i = storage.firstIndex(where: { $0.id == id }) else { return }
        var f = storage[i]
        f.latitude = latitude ?? f.latitude
        f.longitude = longitude ?? f.longitude
        f.population = population ?? f.population
        f.timezone  = timezone  ?? f.timezone
        storage[i] = f
        persist()
    }
    
    private func persist() {
        if let data = try? JSONEncoder().encode(storage) {
            defaults.set(data, forKey: key)
        }
    }
}
