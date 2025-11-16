//
//  FavoritesScreen.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 10/9/25.
//

import SwiftUI

struct FavoritesView: View {

    @StateObject private var vm: FavoritesViewModel
    private let repo: FavoritesRepository
    
    init(repo: FavoritesRepository) {
        self.repo = repo
        _vm = StateObject(wrappedValue: FavoritesViewModel(repo: repo))
    }

    var body: some View {
        VStack(spacing: 12) {
            GradientHeader(
                title: LocalizedStringKey("Favorites"),
                subtitle: LocalizedStringKey("Your saved cities")
            )
            .padding()

            List {
                if vm.items.isEmpty {
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
                    ForEach(vm.items.sorted(by: { $0.addedAt > $1.addedAt })) { f in

                        NavigationLink {
                            CityDetailView(
                                cityId: f.id,
                                displayName: f.name,
                                countryCode: f.countryCode,
                                api: LiveGeoDBService(),
                                repo: repo
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
                                if let idx = vm.items.firstIndex(of: f) {
                                    vm.remove(at: IndexSet(integer: idx))
                                }
                            } label: { Label("Remove", systemImage: "trash") }
                        }
                    }
                    .onDelete(perform: vm.remove)
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
    FavoritesView(
        repo: FavoritesRepoPreviewMock()
    )
}
