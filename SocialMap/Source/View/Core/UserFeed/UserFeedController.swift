import Foundation
import CoreLocation

class UserFeedController: ObservableObject {
    @Published var userLocation: CLLocationCoordinate2D?
    
    func openImage() {}
    
    func loadUserLocation() {
        self.userLocation = CLLocationCoordinate2D(latitude: -3.74192, longitude: -38.51721)
    }
}
