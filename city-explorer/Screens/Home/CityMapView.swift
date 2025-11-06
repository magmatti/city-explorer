//
//  CityMapView.swift
//  final-task
//
//  Created by Mateusz Wójtowicz on 24/9/25.
//

import SwiftUI
import MapKit

struct CityMapView: View {
    
    let coordinate: CLLocationCoordinate2D
    let title: String
    @State private var position: MapCameraPosition
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
        _position = State(initialValue: .region(
            MKCoordinateRegion(
                center: coordinate,
               span: .init(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )
        ))
    }
    
    var body: some View {
        Map(position: $position) {
            Marker(title, coordinate: coordinate)
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapPitchToggle()
            MapScaleView()
        }
    }
}

#Preview {
    Card {
        CityMapView(
            coordinate: PreviewData.coord,
            title: "Cracow"
        )
    }.padding()
}
