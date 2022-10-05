import Foundation
import CoreLocation

class LocationManager {
    var manager: CLLocationManager?
    
    func getCurrentLocation() -> CLLocation? {
        if CLLocationManager.locationServicesEnabled() {
                guard let locationManager = manager else { return nil }
                
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
                        return locationManager.location
                    @unknown default:
                        break
                }
            }
        
            return nil
        }
}
