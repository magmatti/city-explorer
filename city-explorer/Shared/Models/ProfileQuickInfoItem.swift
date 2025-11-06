//
//  ProfileQuickInfoItem.swift
//  city-explorer
//
//  Created by Mateusz Wójtowicz on 24/10/25.
//

import Foundation

struct ProfileQuickInfoItem: Identifiable, Hashable {
    let id = UUID()
    let icon: String
    let title: String
    let value: String
    var link: URL? = nil
}
