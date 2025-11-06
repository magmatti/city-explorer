//
//  FavoritesManagerTests.swift
//  final-taskTests
//
//  Created by Mateusz Wójtowicz on 29/9/25.
//

import Foundation
import XCTest
@testable import final_task

final class FavoritesManagerTests: XCTestCase {
    
    var defaults: UserDefaults!
    var manager: FavoritesManager!
    var suiteName: String!
    
    override func setUp() {
        super.setUp()
        
        suiteName = "FavoritesTests-\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        manager = FavoritesManager(defaults: defaults)
    }
    
    override func tearDown() {
        manager = nil
        if let suiteName = suiteName {
            defaults.removePersistentDomain(forName: suiteName)
        }
        defaults = nil
        suiteName = nil
        super.tearDown()
    }
    
    func testToggleAddAndRemove() {
        let fav = FavoriteCity(
            id: "mock:PL:Warsaw",
            name: "Warsaw",
            countryCode: "PL",
            regionCode: "",
            regionName: ""
        )

        XCTAssertFalse(manager.isFavorite(id: fav.id))

        manager.toggle(fav)
        XCTAssertTrue(manager.isFavorite(id: fav.id))
        XCTAssertEqual(manager.items.count, 1)

        manager.toggle(fav)
        XCTAssertFalse(manager.isFavorite(id: fav.id))
        XCTAssertEqual(manager.items.count, 0)
    }

    func testMergeDetailsUpdatesExistingFavorite() {
        let fav = FavoriteCity(
            id: "mock:PL:Warsaw",
            name: "Warsaw",
            countryCode: "PL",
            regionCode: "",
            regionName: ""
        )
        manager.toggle(fav)
        XCTAssertNotNil(manager.items.first)

        manager.mergeDetails(
            id: fav.id,
            latitude: 52.2297,
            longitude: 21.0122,
            population: 1790000,
            timezone: "Europe/Warsaw"
        )

        let updated = manager.items.first(where: { $0.id == fav.id })!
        XCTAssertEqual(updated.latitude!, 52.2297, accuracy: 0.0001)
        XCTAssertEqual(updated.longitude!, 21.0122, accuracy: 0.0001)
        XCTAssertEqual(updated.population, 1790000)
        XCTAssertEqual(updated.timezone, "Europe/Warsaw")
    }

    func testPersistenceRoundTrip() {
        let fav = FavoriteCity(
            id: "mock:PL:Warsaw",
            name: "Warsaw",
            countryCode: "PL",
            regionCode: "",
            regionName: ""
        )
        
        manager.toggle(fav)

        let again = FavoritesManager(defaults: defaults)
        XCTAssertTrue(again.isFavorite(id: fav.id))
        XCTAssertEqual(again.items.count, 1)
    }
}
