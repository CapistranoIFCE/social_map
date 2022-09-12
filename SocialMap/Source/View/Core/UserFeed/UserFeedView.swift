import SwiftUI
import MapKit

struct UserFeedView: View {
    @StateObject private var controller = UserFeedController()
    
    var body: some View {
        MapView ( coordinate: controller.userLocation?.center ?? CLLocationCoordinate2D(latitude: 3.01, longitude: 4.0))
        .ignoresSafeArea()
        .onAppear {
            controller.checkIfLocationServiceIsEnable()
        }
    }
}

struct UserFeedView_Previews: PreviewProvider {
    static var previews: some View {
        UserFeedView()
    }
}
