//
//  FavoritesRepository.swift
//  city-explorer
//
//  Created by Mateusz Wójtowicz on 6/11/25.
//

import Foundation
import Combine

@MainActor
protocol FavoritesRepository: AnyObject {
    var items: [FavoriteCity] { get }
    var itemsPublisher: AnyPublisher<[FavoriteCity], Never> { get }
    func isFavorite(id: String) -> Bool
    func toggle(_ f: FavoriteCity)
    func remove(at offsets: IndexSet)
    func mergeDetails(
        id: String,
        latitude: Double?, longitude: Double?,
        population: Int?, timezone: String?
    )
}
