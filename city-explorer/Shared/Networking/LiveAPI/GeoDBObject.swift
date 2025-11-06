//
//  GeoDBObject.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 28/9/25.
//

import Foundation

struct GeoDBObject<T: Decodable>: Decodable { let data: T }
