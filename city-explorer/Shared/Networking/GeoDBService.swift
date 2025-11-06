//
//  GeoDBServicing.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 18/9/25.
//

import Foundation
import Combine

protocol GeoDBService {
    func fetchCountries(
        limit: Int,
        offset: Int,
        query: String?,
        sortAsc: Bool
    ) -> AnyPublisher<(items: [Country], total: Int), Never>

    func fetchCountryCities(
        countryCode: String,
        limit: Int,
        offset: Int,
        query: String?
    ) -> AnyPublisher<(items: [City], total: Int), Never>

    func getCityDetails(by id: String) -> AnyPublisher<City, Never>
}
