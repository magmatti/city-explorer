//
//  PlaceDetailDTO.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 27/9/25.
//

import Foundation

struct PlaceDetailDTO: Decodable {
    let id: Int?
    let name: String
    let latitude: Double
    let longitude: Double
    let population: Int?
    let timezone: String?
}
