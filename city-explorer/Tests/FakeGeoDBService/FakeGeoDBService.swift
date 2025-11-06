//
//  FakeGeoDBService.swift
//  final-taskTests
//
//  Created by Mateusz Wójtowicz on 29/9/25.
//

import Foundation
import Combine
@testable import final_task

final class FakeGeoDBService: GeoDBService {

    var countries: [Country] = []
    var cities: [City] = []
    var cityDetails: [String: City] = [:]

    func fetchCountries(
        limit: Int, offset: Int, query: String?, sortAsc: Bool
    ) -> AnyPublisher<(items: [Country], total: Int), Never> {
        let filtered = countries.filter { c in
            guard let q = query, !q.isEmpty else { return true }
            return c.name.localizedCaseInsensitiveContains(q) ||
                   c.countryCode.localizedCaseInsensitiveContains(q)
        }
        let sorted = filtered.sorted { sortAsc ? ($0.name < $1.name) : ($0.name > $1.name) }
        let start = max(0, min(offset, sorted.count))
        let end = max(start, min(start + max(1, limit), sorted.count))
        let page = Array(sorted[start..<end])
        return Just((page, sorted.count)).eraseToAnyPublisher()
    }

    func fetchCountryCities(
        countryCode: String, limit: Int, offset: Int, query: String?
    ) -> AnyPublisher<(items: [City], total: Int), Never> {
        let filtered = cities.filter { $0.countryCode == countryCode }.filter { c in
            guard let q = query, !q.isEmpty else { return true }
            return c.name.localizedCaseInsensitiveContains(q)
        }
        let sorted = filtered.sorted {
            let lp = $0.population ?? 0, rp = $1.population ?? 0
            if lp != rp { return lp > rp }
            return $0.name < $1.name
        }
        let start = max(0, min(offset, sorted.count))
        let end = max(start, min(start + max(1, limit), sorted.count))
        let page = Array(sorted[start..<end])
        return Just((page, sorted.count)).eraseToAnyPublisher()
    }

    func getCityDetails(by id: String) -> AnyPublisher<City, Never> {
        let city = cityDetails[id] ?? City(
            id: id, name: "Unknown", countryCode: "", regionCode: "",
            latitude: 0, longitude: 0, population: nil, timezone: nil
        )
        return Just(city).eraseToAnyPublisher()
    }
}
