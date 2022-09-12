import Foundation
import CoreLocation
import UIKit
import MapKit

class UserFeedController: NSObject, ObservableObject {
    var locationManager: CLLocationManager?
    @Published var userLocation: MKCoordinateRegion?
    
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
                userLocation = MKCoordinateRegion (
                    center: locationManager.location!.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05,
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
