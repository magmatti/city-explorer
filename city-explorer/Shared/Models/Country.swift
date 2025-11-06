//
//  Country.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 18/9/25.
//

import Foundation

struct Country: Identifiable, Hashable {
    var id: String { countryCode }
    let countryCode: String
    let name: String
    let flagEmoji: String?
}
