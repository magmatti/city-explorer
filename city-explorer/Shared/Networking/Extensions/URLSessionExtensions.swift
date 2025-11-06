//
//  URLSessionExtensions.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 26/9/25.
//

import Foundation
import Combine

extension URLSession {
    func dec<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        dataTaskPublisher(for: request)
            .tryMap { pair -> Data in
                guard let http = pair.response as? HTTPURLResponse,
                      (200..<300).contains(http.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return pair.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func dec<T: Decodable>(_ path: String, query: [URLQueryItem] = []) async throws -> T {
        let req = GeoDBAPI.request(path: path, query: query)
        do {
            let (data, resp) = try await data(for: req)
            guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw error
        }
    }
}
