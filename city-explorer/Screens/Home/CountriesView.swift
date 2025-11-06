//
//  HomeScreen.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 10/9/25.
//

import SwiftUI
import MapKit

struct CountriesView: View {
    @StateObject private var vm = CountriesViewModel(api: LiveGeoDBService())
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                GradientHeader(
                    title: LocalizedStringKey("Countries"),
                    subtitle: LocalizedStringKey("Browse & pick a country")
                )
                .padding()
                
                HStack {
                    TextField("Search country or code…", text: $vm.query)
                        .textFieldStyle(.roundedBorder)
                    Button("Search") { vm.offset = 0; vm.reload() }
                }
                .padding(.horizontal)
                
                Picker("Sort", selection: $vm.sortAsc) {
                    Text("A → Z").tag(true)
                    Text("Z → A").tag(false)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .onChange(of: vm.sortAsc) { vm.offset = 0; vm.reload() }
                
                HStack {
                    Spacer()
                    NavigationLink {
                        FavoritesView()
                    } label: {
                        Label("Favorites", systemImage: "heart.fill")
                            .font(.subheadline.weight(.semibold))
                    }
                }
                .padding(.horizontal)
                
                if vm.isLoading {
                    ProgressView("Loading…").padding()
                }
                
                List {
                    ForEach(vm.items) { country in
                        NavigationLink {
                            CountryCitiesView(country: country, api: LiveGeoDBService())
                        } label: {
                            HStack(spacing: 12) {
                                Text(country.flagEmoji ?? "🌍").font(.largeTitle)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(country.name).font(.headline)
                                    Text(country.countryCode).font(.subheadline).foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 6)
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
                    Button("Next") { vm.nextPage() }
                        .disabled(vm.offset + vm.limit >= vm.total)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    CountriesView()
}
