import Foundation
import MapKit


class MapViewCoordinator: NSObject, MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }

        if let annotation = annotation as? UserImageAnnotation {
            let annotationView = MKAnnotationView()
//            let offset = CGPoint(x: annotation.image.size.width / 2, y: -(annotation.image.size.height / 2))
            let annotationFrame = CGSize(width: 64, height: 48)
            
            
            
            annotationView.frame.size = annotationFrame
            annotationView.image = annotation.image.resizeImageTo(size: CGSize(width: 60, height: 60))
            annotationView.contentMode = .scaleToFill
            annotationView.canShowCallout = true
            
//            annotationView.centerOffset = offset

            return annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

    }
    
    
    @objc func handleLongTapGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        guard let gesture = gestureRecognizer as? CustomGestureRecognizer else { return }
        let uiView = gestureRecognizer.view as! MKMapView
        
        if gestureRecognizer.state == .began {
            let touchLocation = gestureRecognizer.location(in: uiView)
            gesture.oneClickCallback!(touchLocation, uiView)
            return
        }
        
        if gestureRecognizer.state == UIGestureRecognizer.State.ended {
            let touchLocation = gestureRecognizer.location(in: uiView)
            let locationCoordinate = uiView.convert(touchLocation, toCoordinateFrom: uiView)
            
            gesture.longPressCallback!(
                Location(
                    latitude: locationCoordinate.latitude,
                    longitude: locationCoordinate.longitude
                ),
                uiView
            )
        }
        
    }
}
