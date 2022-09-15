import Foundation
import SwiftUI
import UIKit
import MapKit

struct MapView: UIViewRepresentable {
    
    var landmarks: [LandmarkAnnotation]
    var coordinator: MapViewCoordinator
    var locationCoordinate: CLLocationCoordinate2D
    
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
    
        return mapView
    }
    
    func configure(with map: MKMapView) {
        UIView.animate(withDuration: 1.0) {
            map.setCenter(locationCoordinate, animated: true)
        }
        map.showsUserLocation = true
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        configure(with: uiView)
        uiView.delegate = self.coordinator
        uiView.addAnnotations(landmarks)
    }
}
