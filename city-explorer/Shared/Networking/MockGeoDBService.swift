//
//  MockGeoDBService.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 18/9/25.
//

import Foundation
import Combine

// Used for SwiftUI previews

final class MockGeoDBService: GeoDBService {

    func fetchCountryCities(
        countryCode: String,
        limit: Int,
        offset: Int,
        query: String?
    ) -> AnyPublisher<(items: [City], total: Int), Never> {

        let regions = regionsByCountry[countryCode] ?? []

        var seen = Set<String>()
        let allCities: [City] = regions.compactMap { region in
            let name = region.capitalName
            guard !name.isEmpty, !seen.contains(name) else { return nil }
            seen.insert(name)

            let info = coords[name] ?? (0, 0, nil, nil)
            return City(
                id: "mock:\(countryCode):\(name)",
                name: name,
                countryCode: countryCode,
                regionCode: region.code,
                latitude: info.0,
                longitude: info.1,
                population: info.2,
                timezone: info.3
            )
        }

        let filtered = allCities.filter { c in
            guard let q = query, !q.isEmpty else { return true }
            return c.name.localizedCaseInsensitiveContains(q)
        }
        
        let sorted = filtered.sorted {
            let lp = $0.population ?? 0
            let rp = $1.population ?? 0
            if lp != rp { return lp > rp }
            return $0.name < $1.name
        }

        let total = sorted.count
        let safeLimit = max(1, limit)
        let start = max(0, min(offset, total))
        let end = max(start, min(start + safeLimit, total))
        let page = (start < end) ? Array(sorted[start..<end]) : []

        return Just((items: page, total: total))
            .delay(for: .milliseconds(200), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func getCityDetails(by id: String) -> AnyPublisher<City, Never> {
        let parts = id.split(separator: ":", maxSplits: 2, omittingEmptySubsequences: false)
        let cc = parts.count >= 2 ? String(parts[1]) : ""
        let cityName = parts.count >= 3 ? String(parts[2]) : id

        let regionCode: String = {
            guard let regions = regionsByCountry[cc] else { return "" }
            return regions.first(where: { $0.capitalName == cityName })?.code ?? ""
        }()

        let info = coords[cityName] ?? (0, 0, nil, nil)
        let city = City(
            id: id,
            name: cityName,
            countryCode: cc,
            regionCode: regionCode,
            latitude: info.0,
            longitude: info.1,
            population: info.2,
            timezone: info.3
        )

        return Just(city)
            .delay(for: .milliseconds(200), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func fetchCountries(
        limit: Int,
        offset: Int,
        query: String?,
        sortAsc: Bool
    ) -> AnyPublisher<(items: [Country], total: Int), Never> {
        let filtered = allCountries
            .filter { c in
                guard let q = query, !q.isEmpty else { return true }
                return c.name.localizedCaseInsensitiveContains(q) ||
                       c.countryCode.localizedCaseInsensitiveContains(q)
            }
            .sorted { sortAsc ? ($0.name < $1.name) : ($0.name > $1.name) }

        let total = filtered.count
        let start = max(0, min(offset, total))
        let end = max(start, min(start + limit, total))
        let page = Array(filtered[start..<end])

        return Just((page, total))
            .delay(for: .milliseconds(250), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    // mocking countries
    private let allCountries: [Country] = [
        .init(countryCode: "US", name: "United States", flagEmoji: "🇺🇸"),
        .init(countryCode: "PL", name: "Poland", flagEmoji: "🇵🇱"),
        .init(countryCode: "DE", name: "Germany", flagEmoji: "🇩🇪"),
        .init(countryCode: "FR", name: "France", flagEmoji: "🇫🇷"),
        .init(countryCode: "IT", name: "Italy", flagEmoji: "🇮🇹"),
        .init(countryCode: "ES", name: "Spain", flagEmoji: "🇪🇸"),
        .init(countryCode: "GB", name: "United Kingdom", flagEmoji: "🇬🇧"),
        .init(countryCode: "JP", name: "Japan", flagEmoji: "🇯🇵"),
        .init(countryCode: "CA", name: "Canada", flagEmoji: "🇨🇦"),
        .init(countryCode: "AU", name: "Australia", flagEmoji: "🇦🇺"),
        .init(countryCode: "BR", name: "Brazil", flagEmoji: "🇧🇷"),
        .init(countryCode: "IN", name: "India", flagEmoji: "🇮🇳")
    ]

    // mocking regions by country (country -> regions (with regional capital names))
    private let regionsByCountry: [String: [Region]] = [
        "US": [
            .init(code: "CA", name: "California", countryCode: "US", capitalName: "Sacramento"),
            .init(code: "NY", name: "New York", countryCode: "US", capitalName: "Albany"),
            .init(code: "TX", name: "Texas", countryCode: "US", capitalName: "Austin"),
        ],
        "PL": [
            .init(code: "MA", name: "Małopolskie", countryCode: "PL", capitalName: "Kraków"),
            .init(code: "MZ", name: "Mazowieckie", countryCode: "PL", capitalName: "Warsaw"),
            .init(code: "SL", name: "Śląskie", countryCode: "PL", capitalName: "Katowice"),
        ],
        "DE": [
            .init(code: "BY", name: "Bavaria", countryCode: "DE", capitalName: "Munich"),
            .init(code: "BE", name: "Berlin", countryCode: "DE", capitalName: "Berlin"),
            .init(code: "NW", name: "North Rhine-Westphalia", countryCode: "DE", capitalName: "Düsseldorf"),
        ],
        "FR": [
            .init(code: "IDF", name: "Île-de-France", countryCode: "FR", capitalName: "Paris"),
            .init(code: "PACA", name: "Provence-Alpes-Côte d'Azur", countryCode: "FR", capitalName: "Marseille"),
            .init(code: "ARA", name: "Auvergne-Rhône-Alpes", countryCode: "FR", capitalName: "Lyon"),
        ],
        "IT": [
            .init(code: "LAZ", name: "Lazio", countryCode: "IT", capitalName: "Rome"),
            .init(code: "LOM", name: "Lombardy", countryCode: "IT", capitalName: "Milan"),
            .init(code: "CAM", name: "Campania", countryCode: "IT", capitalName: "Naples"),
        ],
        "ES": [
            .init(code: "MD", name: "Comunidad de Madrid", countryCode: "ES", capitalName: "Madrid"),
            .init(code: "CT", name: "Catalonia", countryCode: "ES", capitalName: "Barcelona"),
            .init(code: "AN", name: "Andalusia", countryCode: "ES", capitalName: "Seville"),
        ],
        "GB": [
            .init(code: "ENG", name: "England", countryCode: "GB", capitalName: "London"),
            .init(code: "SCT", name: "Scotland", countryCode: "GB", capitalName: "Edinburgh"),
            .init(code: "WLS", name: "Wales", countryCode: "GB", capitalName: "Cardiff"),
        ],
        "JP": [
            .init(code: "13", name: "Tokyo", countryCode: "JP", capitalName: "Tokyo"),
            .init(code: "27", name: "Osaka", countryCode: "JP", capitalName: "Osaka"),
            .init(code: "01", name: "Hokkaido", countryCode: "JP", capitalName: "Sapporo"),
        ],
        "CA": [
            .init(code: "ON", name: "Ontario", countryCode: "CA", capitalName: "Toronto"),
            .init(code: "QC", name: "Quebec", countryCode: "CA", capitalName: "Quebec City"),
            .init(code: "BC", name: "British Columbia", countryCode: "CA", capitalName: "Victoria"),
        ],
        "AU": [
            .init(code: "NSW", name: "New South Wales", countryCode: "AU", capitalName: "Sydney"),
            .init(code: "VIC", name: "Victoria", countryCode: "AU", capitalName: "Melbourne"),
            .init(code: "QLD", name: "Queensland", countryCode: "AU", capitalName: "Brisbane"),
        ],
        "BR": [
            .init(code: "SP", name: "São Paulo", countryCode: "BR", capitalName: "São Paulo"),
            .init(code: "RJ", name: "Rio de Janeiro", countryCode: "BR", capitalName: "Rio de Janeiro"),
            .init(code: "MG", name: "Minas Gerais", countryCode: "BR", capitalName: "Belo Horizonte"),
        ],
        "IN": [
            .init(code: "MH", name: "Maharashtra", countryCode: "IN", capitalName: "Mumbai"),
            .init(code: "DL", name: "Delhi (NCT)", countryCode: "IN", capitalName: "New Delhi"),
            .init(code: "KA", name: "Karnataka", countryCode: "IN", capitalName: "Bengaluru"),
        ],
    ]

    // mocking up city coordinates (name → lat,lon,pop,tz)
    private let coords: [String: (Double, Double, Int? , String?)] = [
        "Sacramento": (38.575764, -121.478851, 525000, "America/Los_Angeles"),
        "Albany": (42.6526, -73.7562, 100000, "America/New_York"),
        "Austin": (30.2672, -97.7431, 965000, "America/Chicago"),
        "Kraków": (50.0647, 19.9450, 800000, "Europe/Warsaw"),
        "Warsaw": (52.2297, 21.0122, 1790000, "Europe/Warsaw"),
        "Katowice": (50.2649, 19.0238, 290000, "Europe/Warsaw"),
        "Munich": (48.1351, 11.5820, 1480000, "Europe/Berlin"),
        "Berlin": (52.5200, 13.4050, 3700000, "Europe/Berlin"),
        "Düsseldorf": (51.2277, 6.7735, 640000, "Europe/Berlin"),
        "Paris": (48.8566, 2.3522, 2140000, "Europe/Paris"),
        "Marseille": (43.2965, 5.3698, 861000, "Europe/Paris"),
        "Lyon": (45.7640, 4.8357, 522000, "Europe/Paris"),
        "Rome": (41.9028, 12.4964, 2870000, "Europe/Rome"),
        "Milan": (45.4642, 9.1900, 1370000, "Europe/Rome"),
        "Naples": (40.8518, 14.2681, 960000, "Europe/Rome"),
        "Madrid": (40.4168, -3.7038, 3220000, "Europe/Madrid"),
        "Barcelona": (41.3851, 2.1734, 1620000, "Europe/Madrid"),
        "Seville": (37.3891, -5.9845, 684000, "Europe/Madrid"),
        "London": (51.5074, -0.1278, 8980000, "Europe/London"),
        "Edinburgh": (55.9533, -3.1883, 548000, "Europe/London"),
        "Cardiff": (51.4816, -3.1791, 366000, "Europe/London"),
        "Tokyo": (35.6762, 139.6503, 13960000, "Asia/Tokyo"),
        "Osaka": (34.6937, 135.5023, 2700000, "Asia/Tokyo"),
        "Sapporo": (43.0618, 141.3545, 1950000, "Asia/Tokyo"),
        "Toronto": (43.6532, -79.3832, 2930000, "America/Toronto"),
        "Quebec City": (46.8139, -71.2080, 549000, "America/Toronto"),
        "Victoria": (48.4284, -123.3656, 92000, "America/Vancouver"),
        "Sydney": ( -33.8688, 151.2093, 5312000, "Australia/Sydney"),
        "Melbourne": (-37.8136, 144.9631, 5078000, "Australia/Melbourne"),
        "Brisbane": (-27.4698, 153.0251, 2560000, "Australia/Brisbane"),
        "São Paulo": (-23.5505, -46.6333, 12300000, "America/Sao_Paulo"),
        "Rio de Janeiro": (-22.9068, -43.1729, 6748000, "America/Sao_Paulo"),
        "Belo Horizonte": (-19.9167, -43.9345, 2510000, "America/Sao_Paulo"),
        "Mumbai": (19.0760, 72.8777, 12400000, "Asia/Kolkata"),
        "New Delhi": (28.6139, 77.2090, 16787941, "Asia/Kolkata"),
        "Bengaluru": (12.9716, 77.5946, 8420000, "Asia/Kolkata"),
    ]
}
