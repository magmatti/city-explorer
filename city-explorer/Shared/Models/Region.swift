//
//  Region.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 18/9/25.
//

import Foundation

struct Region: Codable, Identifiable {
    var id: String { "\(countryCode):\(code)" }
    let code: String
    let name: String
    let countryCode: String
    var capitalName: String
}
