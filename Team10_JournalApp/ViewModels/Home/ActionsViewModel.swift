//
//  ActionsViewModel.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/20/24.
//

import Foundation
import MapKit

@MainActor
class ActionsViewModel: ObservableObject {
    @Published var mapsData: [MapData] = []
    
    func searchNearbyLocations(query: String, title: String, profile: UserProfile) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        searchRequest.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: profile.locLati, longitude: profile.locLongi),
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] response, error in
            guard let response = response, error == nil else {
                print("Error during search: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let annotations = response.mapItems.map { item in
                Annotation(
                    title: item.name ?? "Unknown",
                    subtitle: item.placemark.title ?? "No subtitle",
                    coordinate: item.placemark.coordinate
                )
            }
            
            DispatchQueue.main.async {
                let mapData = MapData(
                    title: title,
                    query: query,
                    region: searchRequest.region,
                    annotations: annotations
                )
                
                self?.mapsData.append(mapData)
            }
        }
        
    }
    
    func openAllInMaps(annotations: [Annotation]) {
        let mapItems = annotations.map { $0.mapItem }
        MKMapItem.openMaps(with: mapItems, launchOptions: nil)
    }
}
