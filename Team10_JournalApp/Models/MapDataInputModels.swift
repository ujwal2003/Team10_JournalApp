//
//  MapData.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/30/24.
//

import Foundation
import MapKit

struct MapData: Identifiable {
    var id = UUID()
    var title: String
    var query: String
    var region: MKCoordinateRegion
    var annotations: [Annotation]
}

struct RecommendedAction {
    let searchQuery: String
    let title: String
    let description: String
}
