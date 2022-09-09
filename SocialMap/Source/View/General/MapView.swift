import Foundation
import SwiftUI
import UIKit
import MapKit

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        configure(with: mapView)
    
        return mapView
    }
    
    func configure(with map: MKMapView) {
        map.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        addPin(on: map)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        configure(with: uiView)
    }
    
    private func addPin(on map: MKMapView) {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        map.addAnnotation(pin)
    }
    
}
