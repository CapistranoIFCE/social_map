import Foundation
import CoreLocation
import UIKit
import MapKit

class UserFeedController: NSObject, ObservableObject {
    @Published var userLocation: MKCoordinateRegion?
    @Published var photoCount: Int = 0
    
    var locationManager: CLLocationManager?
    let mapViewCoordinator = MapViewCoordinator()
    let mockedLandmarks = LandmarkAnnotation.requestMockData()
    
    func goToNextImage() {
        if userLocation != nil {
            let currentUserLocation = mockedLandmarks[photoCount].coordinate
            userLocation!.center = currentUserLocation
            photoCount += 1
            if photoCount >= mockedLandmarks.count {
                photoCount = 0
            }
        }
    }
    
    func goToPreviousImage() {
        if userLocation != nil {
            let currentUserLocation = mockedLandmarks[photoCount].coordinate
            userLocation!.center = currentUserLocation
            photoCount -= 1
            if photoCount <= 0 {
                photoCount = 0
            }
        }
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
