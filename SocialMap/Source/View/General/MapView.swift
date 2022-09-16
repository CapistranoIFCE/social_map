import Foundation
import SwiftUI
import UIKit
import MapKit

struct MapView: UIViewRepresentable {
    
    var landmarks: [LandmarkAnnotation]
    var coordinator: MapViewCoordinator
    var locationCoordinate: CLLocationCoordinate2D
    let onLongPress: (_ location: Location) -> Void
    
    let mapView = MKMapView()
    
    struct MyAnnotationItem: Identifiable {
        var coordinate: CLLocationCoordinate2D
        let id = UUID()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setRegion(
            MKCoordinateRegion(
                center: locationCoordinate,
                span: MKCoordinateSpan (
                    latitudeDelta: 0.01,
                    longitudeDelta: 0.01
                )
            ),
            animated: true
        )
        
        let oLongTapGesture = CustomGestureRecognizer (
            target: coordinator,
            action: #selector(MapViewCoordinator.handleLongTapGesture(gestureRecognizer:))
        )
        
        oLongTapGesture.minimumPressDuration = 0.5
        oLongTapGesture.longPressCallback = onLongPress
        mapView.addGestureRecognizer(oLongTapGesture)
        
        return mapView
    }
    
    func test() {}

    
    func configure(with map: MKMapView) {
        UIView.animate(withDuration: 1.0) {
            map.setCenter(locationCoordinate, animated: true)
        }
        map.showsUserLocation = true
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        configure(with: mapView)
        mapView.delegate = self.coordinator
        mapView.addAnnotations(landmarks)
    }
    
}
