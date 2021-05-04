//
//  ContentView.swift
//  'Za Hunter 2
//
//  Created by Student on 5/4/21.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var region = MKCoordinateRegion(
          center: CLLocationCoordinate2D(
              latitude: 42.15704,
              longitude: -88.14812),
          span: MKCoordinateSpan(
              latitudeDelta: 0.05,
              longitudeDelta: 0.05)
      )
    @StateObject var locationManager = LocationManager()
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    var body: some View {
        Map(
            coordinateRegion: $region,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: $userTrackingMode,
            annotationItems: places) { place in
            MapPin(coordinate: place.annotation.coordinate)
        }
            .onAppear(perform: {
            performSearch(item: "Pizza")
        })
    }
    @State private var places = [Place]()
    
    func performSearch(item: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = item
        searchRequest.region = region
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if let response = response {
                for mapItem in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = mapItem.placemark.coordinate
                        annotation.title = mapItem.name
                        places.append(Place(annotation: annotation, mapItem: mapItem))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Place: Identifiable {
    let id = UUID()
    let annotation: MKPointAnnotation
    let mapItem: MKMapItem
}
