//
//  City.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 18/9/25.
//

import Foundation
import CoreLocation

struct City: Identifiable, Hashable {
    let id: String
    let name: String
    let countryCode: String
    let regionCode: String
    let latitude: Double
    let longitude: Double
    let population: Int?
    let timezone: String?
    
    var coordinates: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
}
