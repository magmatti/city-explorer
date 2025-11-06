//
//  CityDetailViewModel.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 27/9/25.
//

import Foundation
import Combine

final class CityDetailsViewModel: ObservableObject {
    
    @Published var city: City?
    @Published var isLoading = false

    private let api: GeoDBService
    private let cityId: String
    private var bag = Set<AnyCancellable>()

    init(cityId: String, api: GeoDBService) {
        self.cityId = cityId
        self.api = api
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
}
