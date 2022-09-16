import Foundation
import CoreLocation
import UIKit
import MapKit

class UserFeedController: NSObject, ObservableObject {
    @Published var userLocation: MKCoordinateRegion?
    
    var locationManager: CLLocationManager?
    var currentLandmark: LandmarkAnnotation? = nil
    let mapViewCoordinator = MapViewCoordinator()
    let mockedLandmarks = LandmarkAnnotation.requestMockData()
    
    
    func goToNextImage() {
        if userLocation != nil {
            let nearestLandmarkRight = findNearLandmark (
                on: DeviceSide.right,
                in: mockedLandmarks,
                by: currentLandmark?.coordinate ?? userLocation!.center
            )
            currentLandmark = nearestLandmarkRight
            userLocation!.center = nearestLandmarkRight?.coordinate ?? locationManager?.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        }
    }
    
    func goToPreviousImage() {
        if userLocation != nil {
            let nearestLandmarkLeft = findNearLandmark (
                on: DeviceSide.left,
                in: mockedLandmarks,
                by: currentLandmark?.coordinate ?? userLocation!.center
            )
            currentLandmark = nearestLandmarkLeft
            userLocation!.center = nearestLandmarkLeft?.coordinate ?? locationManager?.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        }
    }
    
    func findNearLandmark(on side: DeviceSide, in landmarks: [LandmarkAnnotation], by startLocation: CLLocationCoordinate2D) -> LandmarkAnnotation? {
        
        func findNearLandmarkRight() -> LandmarkAnnotation? {
            var rigthLandmarks = [LandmarkAnnotation]()
            
            for landmark in landmarks {
                if landmark.coordinate.longitude > startLocation.longitude {
                    rigthLandmarks.append(landmark)
                }
            }
            
            rigthLandmarks = rigthLandmarks.sorted(by: { $0.coordinate.longitude < $1.coordinate.longitude })
            
            return rigthLandmarks.first
        }
        
        func findNearLandmarkLeft() -> LandmarkAnnotation? {
            var leftLandmarks = [LandmarkAnnotation]()
            
            for landmark in landmarks {
                if landmark.coordinate.longitude < startLocation.longitude {
                    leftLandmarks.append(landmark)
                }
            }
            
            leftLandmarks = leftLandmarks.sorted(by: { $0.coordinate.longitude > $1.coordinate.longitude })
            
            return leftLandmarks.first
        }
    
        
        return side == DeviceSide.right ? findNearLandmarkRight() : findNearLandmarkLeft()
    }
    
    func checkIfLocationServiceIsEnable() {
        if  CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            checkLocationAuthorization()
        } else {
            // TODO ENVIAR UM ALERTA
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // TODO Avaliar Case
            break
        case .denied:
            // TODO Avaliar Case
            break
        case .authorizedAlways, .authorizedWhenInUse:
            userLocation = MKCoordinateRegion(
                center: locationManager.location!.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.05,
                    longitudeDelta: 0.05
                )
            )
            break
        @unknown default:
            break
        }
    }
}

extension UserFeedController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.checkLocationAuthorization()
    }
}
