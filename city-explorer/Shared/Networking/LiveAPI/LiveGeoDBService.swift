//
//  LiveGeoDBService.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 27/9/25.
//

import Foundation
import Combine

private actor RequestGate {
    
    private var lastFire: Date = .distantPast
    let minInterval: TimeInterval
    init(minInterval: TimeInterval) { self.minInterval = minInterval }
    
    func wait() async {
        let now = Date()
        let delta = now.timeIntervalSince(lastFire)
        if delta < minInterval {
            let ns = UInt64((minInterval - delta) * 1_000_000_000)
            try? await Task.sleep(nanoseconds: ns)
        }
        lastFire = Date()
    }
}

final class LiveGeoDBService: GeoDBService {
    
    private let session = URLSession.shared
    private let detailGate = RequestGate(minInterval: 2.0)
    private var detailCache: [String: City] = [:]
    
    // generating flag emoji that are used in CountriesView
    private static func generateflagEmoji(from countryCode: String) -> String? {
        let code = countryCode.uppercased()
        guard code.count == 2 else { return nil }
        var scalars = String.UnicodeScalarView()
        for scalar in code.unicodeScalars {
            guard let flagScalar = UnicodeScalar(127397 + scalar.value) else { return nil }
            scalars.append(flagScalar)
        }
        
        return String(scalars)
    }
    
    func fetchCountries(
        limit: Int,
        offset: Int,
        query: String?,
        sortAsc: Bool
    ) -> AnyPublisher<(items: [Country], total: Int), Never> {
        var q: [URLQueryItem] = [
            .init(name: "limit", value: String(limit)),
            .init(name: "offset", value: String(offset)),
            .init(name: "sort", value: sortAsc ? "+name" : "-name")
        ]
        
        if let query, !query.isEmpty {
            q.append(.init(name: "namePrefix", value: query))
        }
        
        let req = GeoDBAPI.request(path: "geo/countries", query: q)
        
        return session.dec(req)
            .map { (page: GeoDBPage<CountryDTO>) in
                let items = page.data.map { dto in Country(
                    countryCode: dto.code,
                    name: dto.name,
                    flagEmoji: Self.generateflagEmoji(from: dto.code))
                }
                
                return (items: items, total: page.total)
            }
            .catch { _ in Just((items: [], total: 0)) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func fetchCountryCities(
        countryCode: String,
        limit: Int,
        offset: Int,
        query: String?
    ) -> AnyPublisher<(items: [City], total: Int), Never> {
        let safeLimit = min(limit, 10)
        var q: [URLQueryItem] = [
            .init(name: "types", value: "CITY"),
            .init(name: "sort", value: "-population"),
            .init(name: "limit", value: String(safeLimit)),
            .init(name: "offset", value: String(offset))
        ]
        if let query, !query.isEmpty { q.append(.init(name: "namePrefix", value: query)) }
        
        return Future<(items: [City], total: Int), Never> { promise in
            Task {
                do {
                    let page: GeoDBPage<CityLiteDTO> =
                    try await self.session.dec("geo/countries/\(countryCode)/places", query: q)
                    
                    let items = page.data.map { lite in
                        City(
                            id: String(lite.id),
                            name: lite.name,
                            countryCode: countryCode,
                            regionCode: "",
                            latitude: 0, longitude: 0,
                            population: nil,
                            timezone: nil
                        )
                    }
                    promise(.success((items: items, total: page.total)))
                } catch {
                    promise(.success((items: [], total: 0)))
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func getCityDetails(by id: String) -> AnyPublisher<City, Never> {
        if let cached = detailCache[id] {
            return Just(cached).receive(on: RunLoop.main).eraseToAnyPublisher()
        }

        return Future<City, Never> { promise in
            Task {
                func makeCity(from det: PlaceDetailDTO) -> City {
                    City(
                        id: String(det.id ?? Int(id) ?? 0),
                        name: det.name,
                        countryCode: "",
                        regionCode: "",
                        latitude: det.latitude,
                        longitude: det.longitude,
                        population: det.population,
                        timezone: det.timezone?.replacingOccurrences(of: "__", with: "/")
                    )
                }

                func fetchOnce() async throws -> City {
                    await self.detailGate.wait()
                    let wrapped: GeoDBObject<PlaceDetailDTO> =
                        try await self.session.dec("geo/places/\(id)")
                    let city = makeCity(from: wrapped.data)
                    self.detailCache[id] = city
                    return city
                }

                do {
                    let c = try await fetchOnce()
                    promise(.success(c))
                } catch {
                    for delay in [1.5, 2.5] {
                        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                        do { let c = try await fetchOnce(); promise(.success(c)); return } catch { }
                    }
                    promise(.success(City(
                        id: id, name: "Unknown", countryCode: "", regionCode: "",
                        latitude: 0, longitude: 0, population: nil, timezone: nil
                    )))
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
