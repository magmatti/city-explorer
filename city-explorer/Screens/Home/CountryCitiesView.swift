//
//  CountryCitiesView.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 27/9/25.
//

import SwiftUI

struct CountryCitiesView: View {
    
    @EnvironmentObject private var favorites: FavoritesManager
    @StateObject var vm: CitiesViewModel

    init(country: Country, api: GeoDBService) {
        _vm = StateObject(wrappedValue: CitiesViewModel(country: country, api: api))
    }

    var body: some View {
        VStack(spacing: 12) {
            GradientHeader(title: vm.country.name, subtitle: vm.country.countryCode)

            HStack {
                TextField("Search city…", text: $vm.query)
                    .textFieldStyle(.roundedBorder)
                Button("Search") { vm.offset = 0; vm.reload() }
            }
            .padding(.horizontal)

            if vm.isLoading { ProgressView("Loading…").padding() }

            List {
                ForEach(vm.items) { city in
                    let fav = FavoriteCity(
                        id: city.id,
                        name: city.name,
                        countryCode: vm.country.countryCode,
                        regionCode: city.regionCode,
                        regionName: ""
                    )

                    HStack {
                        NavigationLink {
                            CityDetailView(
                                cityId: city.id,
                                displayName: city.name,
                                countryCode: vm.country.countryCode,
                                api: LiveGeoDBService()
                            )
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(city.name).font(.headline)
                                Text(vm.country.countryCode)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .contentShape(Rectangle())
                        }

                        Spacer(minLength: 12)

                        Button {
                            favorites.toggle(fav)
                        } label: {
                            Image(systemName: favorites.isFavorite(id: fav.id) ? "heart.fill" : "heart")
                                .foregroundStyle(.pink.opacity(0.95))
                                .font(.title3)
                                .accessibilityLabel(
                                    favorites.isFavorite(id: fav.id) ? "Remove from favorites" : "Add to favorites"
                                )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 6)
                    .swipeActions {
                        Button {
                            favorites.toggle(fav)
                        } label: {
                            Label(
                                favorites.isFavorite(id: fav.id) ? "Unfavorite" : "Favorite",
                                systemImage: favorites.isFavorite(id: fav.id) ? "heart.slash" : "heart.fill"
                            )
                        }
                        .tint(.pink)
                    }
                }
            }
            .listStyle(.plain)

            HStack {
                Button("Prev") { vm.prevPage() }.disabled(vm.offset == 0)
                Spacer()
                Text("\(min(vm.offset + vm.limit, vm.total))/\(vm.total)")
                    .font(.footnote).foregroundStyle(.secondary)
                Spacer()
                Button("Next") { vm.nextPage() }.disabled(vm.offset + vm.limit >= vm.total)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CountryCitiesView(
        country: PreviewData.country,
        api: MockGeoDBService()
    ).environmentObject(FavoritesManager())
}
