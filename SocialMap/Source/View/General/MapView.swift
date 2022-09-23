import Foundation
import SwiftUI
import UIKit
import MapKit

struct MapView: UIViewRepresentable {
    
    var landmarks: [UserImageAnnotation]
    var coordinator: MapViewCoordinator
    var locationCoordinate: CLLocationCoordinate2D
    let onLongPress: (_ location: Location, _ mapView: MKMapView) -> Void
    let oneClickCallback: (_ point: CGPoint, _ mapView: MKMapView) -> Void
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        let gesture = configureGesture()
        
        mapView.delegate = self.coordinator
        mapView.addGestureRecognizer(gesture)
        self.coordinator.mapViewInstance = mapView
        
        mapView.setRegion(
            MKCoordinateRegion(
                center: locationCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)),
            animated: true
        )
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        configure(with: uiView)
        
        uiView.addAnnotations(landmarks)
    }
    
    private func configureGesture() -> CustomGestureRecognizer {
        let onLongTapGesture = CustomGestureRecognizer (
            target: coordinator,
            action: #selector(MapViewCoordinator.handleLongTapGesture(gestureRecognizer:))
        )
        
        onLongTapGesture.minimumPressDuration = 0.5
        onLongTapGesture.longPressCallback = onLongPress
        onLongTapGesture.oneClickCallback = oneClickCallback
        
        return onLongTapGesture
    }
    
    private func configure(with map: MKMapView) {
        UIView.animate(withDuration: 1.0) {
            map.setCenter(locationCoordinate, animated: true)
        }
        map.showsUserLocation = true
    }

}
