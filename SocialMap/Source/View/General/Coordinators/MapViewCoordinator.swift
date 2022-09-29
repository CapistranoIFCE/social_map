import Foundation
import MapKit


class MapViewCoordinator: NSObject, MKMapViewDelegate {
    weak var mapViewInstance: MKMapView?
    weak var controllerInstance: UserFeedController?
    
    init(controllerInstance: UserFeedController? = nil) {
        self.controllerInstance = controllerInstance
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }

        if let annotation = annotation as? UserImageAnnotation {
            let annotationView = MKAnnotationView()
            let annotationFrame = CGSize(width: 64, height: 48)
            let annotationImage = annotation.images.last!.resizeImageTo (
                size: CGSize(width: 84, height: 64)
            )?.withRoundedCorners(radius: 16)
            
            annotationView.frame.size = annotationFrame
            annotationView.image = annotationImage
            annotationView.layer.cornerRadius = 20
            annotationView.contentMode = .scaleAspectFit
//            annotationView.canShowCallout = true
            
            return annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let controllerInstance = controllerInstance else { return }
        guard let selectedAnnotation = view.annotation as? UserImageAnnotation else { return }
        controllerInstance.callAnnotationDetails(selectedAnnotation)
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
