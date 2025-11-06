//
//  CityDetailDTO.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 26/9/25.
//

import Foundation

struct CityDetailDTO: Decodable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let population: Int?
    let timezone: String?
}
