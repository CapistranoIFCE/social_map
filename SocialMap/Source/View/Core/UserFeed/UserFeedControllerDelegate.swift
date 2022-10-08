import Foundation
import UIKit
import MapKit

protocol UserFeedControllerDelegate: AnyObject {
    func didTapOnMap(at point: CGPoint, in mapView: MKMapView)
    func didLongPressOnMap(at location: Location, in mapView: MKMapView)
    func changeCurrentLandmark(to newLandmark: UserImageAnnotation?)
    func showDeleteAlert()
}
