//
//  CityDetailViewModel.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 27/9/25.
//

import Foundation
import Combine

@MainActor
final class CityDetailsViewModel: ObservableObject {
    
    @Published var city: City?
    @Published var isLoading = false
    @Published private(set) var favoriteIds: Set<String> = []
    
    private let api: GeoDBService
    private let cityId: String
    private var bag = Set<AnyCancellable>()
    
    private let repo: FavoritesRepository

    init(cityId: String, api: GeoDBService, repo:FavoritesRepository) {
        self.cityId = cityId
        self.api = api
        self.repo = repo
        
        repo.itemsPublisher
            .map { Set($0.map(\.id)) }
            .sink { [weak self] ids in
                self?.favoriteIds = ids
            }
            .store(in: &bag)
        
        load()
    }

    func load() {
        isLoading = true
        api.getCityDetails(by: cityId)
            .sink { [weak self] c in
                self?.city = c
                self?.isLoading = false
            }
            .store(in: &bag)
    }
    
    func isFavorite(_ id: String) -> Bool {
        favoriteIds.contains(id)
    }
    
    func toggleFavorite(_ f: FavoriteCity) {
        repo.toggle(f)
    }
    
   func mergeFavoriteDetails(
       id: String,
       latitude: Double?, longitude: Double?,
       population: Int?, timezone: String?
   ) {
       repo.mergeDetails(
           id: id,
           latitude: latitude, longitude: longitude,
           population: population, timezone: timezone
       )
   }
}
