//
//  CityDetailsViewModelTests.swift
//  final-taskTests
//
//  Created by Mateusz Wójtowicz on 29/9/25.
//

import XCTest
import Combine
@testable import final_task

final class CityDetailsViewModelTests: XCTestCase {

    var service: FakeGeoDBService!
    var vm: CityDetailsViewModel!
    var bag = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        service = FakeGeoDBService()
        service.cityDetails["mock:PL:Warsaw"] = City(
            id: "mock:PL:Warsaw",
            name: "Warsaw",
            countryCode: "PL",
            regionCode: "",
            latitude: 52.2297,
            longitude: 21.0122,
            population: 1790000,
            timezone: "Europe/Warsaw"
        )
        vm = CityDetailsViewModel(cityId: "mock:PL:Warsaw", api: service)
    }

    override func tearDown() {
        bag.removeAll()
        vm = nil
        service = nil
        super.tearDown()
    }

    func testLoadsCityDetails() {
        let exp = expectation(description: "details loaded")
        vm.$isLoading.dropFirst().sink { loading in
            if !loading { exp.fulfill() }
        }.store(in: &bag)

        vm.load()
        wait(for: [exp], timeout: 1.0)

        XCTAssertEqual(vm.city?.name, "Warsaw")
        XCTAssertEqual(vm.city?.population, 1790000)
        XCTAssertEqual(vm.city?.timezone, "Europe/Warsaw")
        XCTAssertEqual(vm.city?.latitude ?? 0, 52.2297, accuracy: 0.0001)
    }
}
