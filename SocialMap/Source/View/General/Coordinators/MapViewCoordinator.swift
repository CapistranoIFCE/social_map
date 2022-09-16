import Foundation
import MapKit


class MapViewCoordinator: NSObject, MKMapViewDelegate {
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customView")
        annotationView.canShowCallout = true
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
            imageView.image = UIImage(named: "eurotruck")
            imageView.layer.cornerRadius = imageView.layer.frame.size.width / 2
            imageView.layer.masksToBounds = true
            annotationView.addSubview(imageView)
        
//        annotationView.image = UIImage()
        
        annotationView.frame = CGRect(x: 0.0, y: 0.0, width: 64, height: 48)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //
    }
    
    
//    @objc func handleLongTapGesture(gestureRecognizer: UILongPressGestureRecognizer, callBack: () -> Void) {
    @objc func handleLongTapGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        print(#function)
        let uiView = gestureRecognizer.view as! MKMapView
        
//        if gestureRecognizer.state != UIGestureRecognizer.State.ended {
            let touchLocation = gestureRecognizer.location(in: uiView)
            let locationCoordinate = uiView.convert(touchLocation, toCoordinateFrom: uiView)
            
            print("Tapped at latitude: \(locationCoordinate.latitude), Longitude \(locationCoordinate.longitude) " )
            
            let myPin = MKPointAnnotation()
            myPin.coordinate = locationCoordinate
            
            myPin.title = "Tapped at latitude: \(locationCoordinate.latitude), Longitude \(locationCoordinate.longitude) "
            uiView.addAnnotation(myPin)
//        }
//
//        if gestureRecognizer.state != UIGestureRecognizer.State.began {
//            return
//        }
    }
}
