//
//  GeoDBPage.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 26/9/25.
//

import Foundation

struct GeoDBPage<T: Decodable>: Decodable {
    let data: [T]
    let metadata: Meta?
    struct Meta: Decodable { let totalCount: Int? }
    var total: Int { metadata?.totalCount ?? data.count }
}
