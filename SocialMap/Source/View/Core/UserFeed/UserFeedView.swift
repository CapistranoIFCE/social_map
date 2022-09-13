import SwiftUI
import MapKit

struct UserFeedView: View {
    @StateObject private var controller = UserFeedController()
    
    var body: some View {
        MapView ( coordinate: controller.userLocation?.center ?? .init())
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
