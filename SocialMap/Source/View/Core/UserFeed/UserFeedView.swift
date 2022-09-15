import SwiftUI
import MapKit


struct UserFeedView: View {
    @StateObject private var controller = UserFeedController()
    
    var body: some View {
        GeometryReader { (geometry) in
            MapView (
                landmarks: controller.mockedLandmarks,
                coordinator: controller.mapViewCoordinator,
                locationCoordinate: controller.userLocation?.center ?? .init()
//                onTap: { _ in }
            )
//            .gesture(DragGesture(minimumDistance: 0).onEnded({
//                (value) in
//                controller.mapViewCoordinator.handleTapGesture(location: CLLocationCoordinate2D(
//                    latitude: value.location.x, longitude: value.location.y))
//            }))
            
            HStack {
                Rectangle()
                    .frame(width: geometry.size.width * 0.1, height: geometry.size.height)
                    .onTapGesture(count: 2, perform: {
                        controller.goToNextImage()
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    } )
                    .onTapGesture {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                    .foregroundColor(.blue.opacity(0.00001))
                
                Spacer()
    
                Rectangle()
                    .frame(width: geometry.size.width * 0.1, height: geometry.size.height)
                    .onTapGesture(count: 2, perform: {
                        controller.goToPreviousImage()
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    } )
                    .onTapGesture {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                    .foregroundColor(.blue.opacity(0.00001))
            }
        }
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
