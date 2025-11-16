//
//  FavoritesRepoPreviewMock.swift
//  city-explorer
//
//  Created by Mateusz Wójtowicz on 7/11/25.
//

import Foundation
import Combine

@MainActor
final class FavoritesRepoPreviewMock: FavoritesRepository {
    
    @Published var _items: [FavoriteCity]
    
    init(items: [FavoriteCity] = []) {
        _items = items
    }
    
    var items: [FavoriteCity] { _items }
    
    var itemsPublisher: AnyPublisher<[FavoriteCity], Never> { $_items.eraseToAnyPublisher() }

    func isFavorite(id: String) -> Bool {
        _items.contains { $0.id == id }
    }
    
    func toggle(_ f: FavoriteCity) {
        if let i = _items.firstIndex(where: { $0.id == f.id }) { _items.remove(at: i) } else { _items.append(f) }
    }
    
    func remove(at offsets: IndexSet) {
        _items.remove(atOffsets: offsets)
    }
    
    func mergeDetails(id: String, latitude: Double?, longitude: Double?, population: Int?, timezone: String?) {}
}
