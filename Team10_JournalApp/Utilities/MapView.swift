//
//  MapView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/20/24.
//

import SwiftUI
import MapKit

struct Annotation: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var coordinate: CLLocationCoordinate2D
    
    var pointAnnotation: MKPointAnnotation {
        let point = MKPointAnnotation()
        point.title = title
        point.subtitle = subtitle
        point.coordinate = coordinate
        return point
    }
    
    var mapItem: MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate)
        let item = MKMapItem(placemark: placemark)
        item.name = title
        return item
    }
}

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var annotations: [Annotation]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
//        let longPress = UILongPressGestureRecognizer(
//            target: context.coordinator,
//            action: #selector(context.coordinator.longPressGesture(recognizer:))
//        )
//        
//        longPress.minimumPressDuration = 1.5
//        mapView.addGestureRecognizer(longPress)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations.map({ $0.pointAnnotation }))
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var longPressPinCount = 0
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        @objc func longPressGesture(recognizer: UILongPressGestureRecognizer) {
            if recognizer.state == .began {
                let touchPoint = recognizer.location(in: recognizer.view)
                let longPressMapCoordinate = (recognizer.view as! MKMapView).convert(touchPoint, toCoordinateFrom: recognizer.view)
                
                longPressPinCount += 1
                let longPressAnnotation = Annotation(
                    title: "Pin #\(longPressPinCount)",
                    subtitle: "Marked place \(longPressPinCount)",
                    coordinate: longPressMapCoordinate
                )
                
                parent.annotations.append(longPressAnnotation)
            }
        }
        
        
    }
}
