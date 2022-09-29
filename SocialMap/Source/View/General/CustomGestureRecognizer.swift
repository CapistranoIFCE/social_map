import Foundation
import UIKit
import MapKit

class CustomGestureRecognizer : UILongPressGestureRecognizer {
    
    var longPressCallback: ((_ location: Location, _ mapView: MKMapView) -> Void)?
    var oneClickCallback: ((_ point: CGPoint, _ mapView: MKMapView) -> Void)?
}
