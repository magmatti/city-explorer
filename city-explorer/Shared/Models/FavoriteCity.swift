//
//  FavoriteCity.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 25/9/25.
//

import Foundation

struct FavoriteCity: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let countryCode: String
    let regionCode: String
    let regionName: String
    var latitude: Double? = nil
    var longitude: Double? = nil
    var population: Int? = nil
    var timezone: String? = nil
    var addedAt: Date = Date()
    
    static func makeId(
        country: String,
        region: String,
        capital: String
    ) -> String {
        "\(country):\(region):\(capital)"
    }
}
