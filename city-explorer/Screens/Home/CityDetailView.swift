//
//  CityDetailsFromIDView.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 27/9/25.
//

import SwiftUI
import MapKit

struct CityDetailView: View {

    @StateObject private var vm: CityDetailsViewModel

    private let fallbackName: String
    private let countryCode: String
    private let cityId: String

    init(
        cityId: String,
        displayName: String,
        countryCode: String,
        api: GeoDBService,
        repo: FavoritesRepository
    ) {
        _vm = StateObject(wrappedValue: CityDetailsViewModel(cityId: cityId, api: api, repo: repo))
        self.fallbackName = displayName
        self.countryCode = countryCode
        self.cityId = cityId
    }

    private var headerTitle: String {
        let name = vm.city?.name.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if name.isEmpty || name == "Unknown" { return fallbackName }
        return name
    }

    private var hasValidCoords: Bool {
        guard let c = vm.city else { return false }
        return c.latitude != 0 || c.longitude != 0
    }
    
    private var baseFavorite: FavoriteCity {
        FavoriteCity(
            id: vm.city?.id ?? cityId,
            name: headerTitle,
            countryCode: countryCode,
            regionCode: vm.city?.regionCode ?? "",
            regionName: ""
        )
    }

    var body: some View {
        VStack(spacing: 12) {
            GradientHeader(title: headerTitle, subtitle: countryCode)

            Group {
                if vm.isLoading {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.secondarySystemGroupedBackground))
                        .frame(height: 240)
                        .overlay(ProgressView())
                } else if let city = vm.city, (city.latitude != 0 || city.longitude != 0) {
                    Map(initialPosition: .region(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude),
                            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                        )
                    ))
                    .frame(height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.secondarySystemGroupedBackground))
                        .frame(height: 240)
                        .overlay(Text("Map unavailable").foregroundStyle(.secondary))
                }
            }
            .padding(.horizontal)
            
            List {
                if vm.isLoading {
                    Section("Details") {
                        ProgressView("Loading…")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 12)
                    }
                } else if let city = vm.city {
                    Section("Details") {
                        LabeledContent("Population", value: city.population.map { "\($0)" } ?? "—")
                        LabeledContent("Timezone", value: city.timezone ?? "—")
                        LabeledContent("Coords", value: String(format: "%.4f, %.4f", city.latitude, city.longitude))
                    }
                } else {
                    Section("Details") {
                        Text("City not found").foregroundStyle(.secondary)
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    vm.toggleFavorite(baseFavorite)
                    if let c = vm.city {
                        vm.mergeFavoriteDetails(
                            id: baseFavorite.id,
                            latitude: c.latitude,
                            longitude: c.longitude,
                            population: c.population,
                            timezone: c.timezone
                        )
                    }
                } label: {
                    Image(systemName: vm.isFavorite(baseFavorite.id) ? "heart.fill" : "heart")
                           .accessibilityLabel(vm.isFavorite(baseFavorite.id)
                                               ? "Remove from favorites"
                                               : "Add to favorites")
                }
            }
        }
        .onChange(of: vm.city) { _, newValue in
            guard let c = newValue else { return }
            vm.mergeFavoriteDetails(
                id: baseFavorite.id,
                latitude: c.latitude, longitude: c.longitude,
                population: c.population, timezone: c.timezone
            )
        }
    }
}

#Preview {
    CityDetailView(
        cityId: "mock:PL:Warsaw",
        displayName: "Warsaw",
        countryCode: "PL",
        api: MockGeoDBService(),
        repo: FavoritesRepoPreviewMock()
    )
}
