//
//  CountriesViewModelTests.swift
//  final-taskTests
//
//  Created by Mateusz Wójtowicz on 29/9/25.
//

import XCTest
@testable import final_task

final class CountriesViewModelTests: XCTestCase {

    var service: FakeGeoDBService!
    var vm: CountriesViewModel!

    override func setUp() {
        super.setUp()
        service = FakeGeoDBService()
        
        service.countries = [
            Country(countryCode: "PL", name: "Poland", flagEmoji: "🇵🇱"),
            Country(countryCode: "DE", name: "Germany", flagEmoji: "🇩🇪"),
            Country(countryCode: "FR", name: "France", flagEmoji: "🇫🇷"),
            Country(countryCode: "IT", name: "Italy", flagEmoji: "🇮🇹"),
            Country(countryCode: "ES", name: "Spain", flagEmoji: "🇪🇸"),
            Country(countryCode: "GB", name: "United Kingdom", flagEmoji: "🇬🇧"),
            Country(countryCode: "JP", name: "Japan", flagEmoji: "🇯🇵"),
            Country(countryCode: "CA", name: "Canada", flagEmoji: "🇨🇦"),
            Country(countryCode: "AU", name: "Australia", flagEmoji: "🇦🇺"),
            Country(countryCode: "BR", name: "Brazil", flagEmoji: "🇧🇷"),
            Country(countryCode: "US", name: "United States", flagEmoji: "🇺🇸"),
            Country(countryCode: "IN", name: "India", flagEmoji: "🇮🇳"),
        ]
        
        vm = CountriesViewModel(api: service)
    }

    private func awaitNextItemsUpdate(_ action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "items updated")
        var token: Any?
        token = vm.$items.dropFirst().first().sink { _ in
            exp.fulfill()
            _ = token
        }
        action()
        wait(for: [exp], timeout: 2.0)
    }

    func testInitialLoadAscending() {
        vm.limit = 5
        vm.sortAsc = true
        awaitNextItemsUpdate { vm.reload() }

        XCTAssertEqual(vm.items.map(\.name), ["Australia", "Brazil", "Canada", "France", "Germany"])
        XCTAssertEqual(vm.total, 12)
    }

    func testPaginationNextPrev() {
        vm.limit = 4
        vm.sortAsc = true
        awaitNextItemsUpdate { vm.reload() }
        XCTAssertEqual(vm.items.map(\.name), ["Australia", "Brazil", "Canada", "France"])

        awaitNextItemsUpdate { vm.nextPage() }
        XCTAssertEqual(vm.items.map(\.name), ["Germany", "India", "Italy", "Japan"])

        awaitNextItemsUpdate { vm.prevPage() }
        XCTAssertEqual(vm.items.map(\.name), ["Australia", "Brazil", "Canada", "France"])
    }

    func testSearchByNameOrCode() {
        vm.limit = 10
        vm.sortAsc = true
        vm.query = "pol"
        awaitNextItemsUpdate { vm.reload() }
        XCTAssertEqual(vm.items.map(\.name), ["Poland"])
        XCTAssertEqual(vm.total, 1)

        vm.query = "JP"
        awaitNextItemsUpdate { vm.reload() }
        XCTAssertEqual(vm.items.map(\.name), ["Japan"])
        XCTAssertEqual(vm.total, 1)
    }

    func testSortDescending() {
        vm.limit = 5
        vm.sortAsc = false
        awaitNextItemsUpdate { vm.reload() }

        XCTAssertEqual(vm.items.map(\.name), ["United States", "United Kingdom", "Spain", "Poland", "Japan"])
    }
}
