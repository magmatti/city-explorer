//
//  CitiesViewModelTests.swift
//  final-taskTests
//
//  Created by Mateusz Wójtowicz on 29/9/25.
//

import XCTest
@testable import final_task

final class CitiesViewModelTests: XCTestCase {

    var service: FakeGeoDBService!
    var vm: CitiesViewModel!

    override func setUp() {
        super.setUp()
        service = FakeGeoDBService()
        
        service.cities = [
            City(
                id: "1",
                name: "Warsaw",
                countryCode: "PL",
                regionCode: "",
                latitude: 0,
                longitude: 0,
                population: 1_790_000,
                timezone: "Europe/Warsaw"
            ),
            City(
                id: "2",
                name: "Kraków",
                countryCode: "PL",
                regionCode: "",
                latitude: 0,
                longitude: 0,
                population: 800_000,
                timezone: "Europe/Warsaw"
            ),
            City(
                id: "3",
                name: "Gdańsk",
                countryCode: "PL",
                regionCode: "",
                latitude: 0,
                longitude: 0,
                population: 486_000,
                timezone: "Europe/Warsaw"
            ),
            City(
                id: "4",
                name: "Lublin",
                countryCode: "PL",
                regionCode: "",
                latitude: 0,
                longitude: 0,
                population: 338_000,
                timezone: "Europe/Warsaw"
            )
        ]
        
        let country = Country(countryCode: "PL", name: "Poland", flagEmoji: "🇵🇱")
        vm = CitiesViewModel(country: country, api: service)
    }

    private func awaitNextItemsUpdate(_ action: () -> Void) {
        let exp = expectation(description: "items updated")
        var token: Any?
        token = vm.$items.dropFirst().first().sink { _ in
            exp.fulfill()
            _ = token
        }
        action()
        wait(for: [exp], timeout: 2.0)
    }

    func testInitialLoadLoadsFirstPage() {
        vm.limit = 2
        awaitNextItemsUpdate { vm.reload() }
        XCTAssertEqual(vm.items.count, 2)
        XCTAssertEqual(vm.total, 4)
        XCTAssertEqual(vm.items.first?.name, "Warsaw")
    }

    func testPaginationNextPrev() {
        vm.limit = 2
        awaitNextItemsUpdate { vm.reload() }
        XCTAssertEqual(vm.items.map(\.name), ["Warsaw", "Kraków"])

        awaitNextItemsUpdate { vm.nextPage() }
        XCTAssertEqual(vm.items.map(\.name), ["Gdańsk", "Lublin"])

        awaitNextItemsUpdate { vm.prevPage() }
        XCTAssertEqual(vm.items.map(\.name), ["Warsaw", "Kraków"])
    }

    func testSearchFilters() {
        vm.limit = 10
        vm.query = "kra"
        awaitNextItemsUpdate { vm.reload() }
        XCTAssertEqual(vm.items.map(\.name), ["Kraków"])
        XCTAssertEqual(vm.total, 1)
    }
}
