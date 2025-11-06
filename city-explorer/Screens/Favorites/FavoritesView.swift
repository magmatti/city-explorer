//
//  FavoritesScreen.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 10/9/25.
//

import SwiftUI

struct FavoritesView: View {

    @EnvironmentObject private var favorites: FavoritesManager

    var body: some View {
        VStack(spacing: 12) {
            GradientHeader(
                title: LocalizedStringKey("Favorites"),
                subtitle: LocalizedStringKey("Your saved cities")
            )
            .padding()

            List {
                if favorites.items.isEmpty {
                    Section {
                        VStack(spacing: 8) {
                            Text("No favorites yet").font(.headline)
                            Text("Tap the heart on a city or swipe a row in the list.")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 12)
                    }
                } else {
                    ForEach(favorites.items.sorted(by: { $0.addedAt > $1.addedAt })) { f in

                        NavigationLink {
                            CityDetailView(
                                cityId: f.id,
                                displayName: f.name,
                                countryCode: f.countryCode,
                                api: LiveGeoDBService()
                            )
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(f.name).font(.headline)
                                if !f.regionName.isEmpty {
                                    Text("\(f.regionName), \(f.countryCode)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                } else {
                                    Text(f.countryCode)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        .listRowInsets(.init(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .swipeActions {
                            Button(role: .destructive) {
                                if let idx = favorites.items.firstIndex(of: f) {
                                    favorites.remove(at: IndexSet(integer: idx))
                                }
                            } label: { Label("Remove", systemImage: "trash") }
                        }
                    }
                    .onDelete(perform: favorites.remove)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .padding(.horizontal)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesManager())
}
