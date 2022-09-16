import Foundation
import MapKit


class MapViewCoordinator: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           guard !(annotation is MKUserLocation) else { return nil }
           let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customView")
           annotationView.canShowCallout = true
           annotationView.image = UIImage(systemName: "photo")
           annotationView.frame = CGRect(x: 0.0, y: 0.0, width: 64, height: 48)
           return annotationView
       }
       
       func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
           //
       }
    
    @objc func handleLongTapGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        let gesture = gestureRecognizer as! CustomGestureRecognizer
        let uiView = gestureRecognizer.view as! MKMapView
        
        if gestureRecognizer.state == .began {
            let touchLocation = gestureRecognizer.location(in: uiView)
            gesture.oneClickCallback!(touchLocation)
            return
        }
        
        if gestureRecognizer.state == UIGestureRecognizer.State.ended {
            let touchLocation = gestureRecognizer.location(in: uiView)
            let locationCoordinate = uiView.convert(touchLocation, toCoordinateFrom: uiView)
            
            let myPin = MKPointAnnotation()
            myPin.coordinate = locationCoordinate
            myPin.title = "Tapped at latitude: \(locationCoordinate.latitude), Longitude \(locationCoordinate.longitude) "
            uiView.addAnnotation(myPin)
            
            gesture.longPressCallback!(
                Location(
                    latitude: locationCoordinate.latitude,
                    longitude: locationCoordinate.longitude
                )
            )
        }

    }
}
