import SwiftUI
import MapKit

struct UserFeedView: View {
    @ObservedObject private var controller = UserFeedController()
    
    var body: some View {
        MapView ( coordinate: controller.userLocation ?? CLLocationCoordinate2D(latitude: 3.01, longitude: 4.0))
        .ignoresSafeArea()
        .onAppear {
            controller.loadUserLocation()
        }
    }
}

struct UserFeedView_Previews: PreviewProvider {
    static var previews: some View {
        UserFeedView()
    }
}
