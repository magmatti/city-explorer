//
//  CountriesViewModel.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 19/9/25.
//

import Foundation
import Combine

final class CountriesViewModel: ObservableObject {
    
    @Published var items: [Country] = []
    @Published var isLoading = false
    @Published var query = ""
    @Published var sortAsc = true
    @Published var total = 0
    @Published var limit = 10
    @Published var offset = 0
    
    private let api: GeoDBService
    private var bag = Set<AnyCancellable>()
    
    init(api: GeoDBService) {
        self.api = api
        reload()
    }
    
    func reload() {
        isLoading = true
        api.fetchCountries(
            limit: limit,
            offset: offset,
            query: query,
            sortAsc: sortAsc
        )
        .sink { [weak self] result in
            self?.items = result.items
            self?.total = result.total
            self?.isLoading = false
        }.store(in: &bag)
    }
    
    func nextPage() {
        guard offset + limit < total else { return }
        offset += limit
        reload()
    }
    
    func prevPage() {
        offset = max(0, offset - limit)
        reload()
    }
}
