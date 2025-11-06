//
//  GeoDBAPI.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 26/9/25.
//

import Foundation

enum GeoDBAPI {
    
    static let base = URL(string: "https://wft-geo-db.p.rapidapi.com/v1")!
    
    static func request(path: String, query: [URLQueryItem] = []) -> URLRequest {
        var comps = URLComponents(
            url: base.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        )!
        
        if !query.isEmpty { comps.queryItems = query }
        var r = URLRequest(url: comps.url!)
        
        r.setValue(GeoDBKeys.apiKey, forHTTPHeaderField: "X-RapidAPI-Key")
        r.setValue(GeoDBKeys.host, forHTTPHeaderField: "X-RapidAPI-Host")
        r.timeoutInterval = 30
        
        return r
    }
}
