//
//  PreviewData.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 24/9/25.
//

import Foundation
import MapKit

enum PreviewData {
    static let country = Country(countryCode: "PL", name: "Poland", flagEmoji: "🇵🇱")
    static let region  = Region(code: "MZ", name: "Mazowieckie", countryCode: "PL", capitalName: "Warsaw")
    static let coord   = CLLocationCoordinate2D(latitude: 50.0647, longitude: 19.9450)
}
