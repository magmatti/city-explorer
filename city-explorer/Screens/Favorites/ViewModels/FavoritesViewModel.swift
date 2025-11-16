//
//  FavoritesViewModel.swift
//  city-explorer
//
//  Created by Mateusz Wójtowicz on 7/11/25.
//

import Foundation
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    
    @Published private(set) var items: [FavoriteCity] = []
    private let repo: FavoritesRepository
    private var bag = Set<AnyCancellable>()

    init(repo: FavoritesRepository) {
        self.repo = repo
        repo.itemsPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$items)
    }

    func remove(at offsets: IndexSet) {
        repo.remove(at: offsets)
    }
    
    func isFavorite(id: String) -> Bool {
        repo.isFavorite(id: id)
    }
}
