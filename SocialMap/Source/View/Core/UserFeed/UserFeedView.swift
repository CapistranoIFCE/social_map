import SwiftUI
import MapKit

struct UserFeedView: View {
    @ObservedObject private var controller = UserFeedController()
    
    var body: some View {
        GeometryReader { (geometry) in
            MapView (
                landmarks: controller.mockedLandmarks,
                coordinator: controller.mapViewCoordinator,
                locationCoordinate: controller.userLocation?.center ?? .init()
            )
            HStack {
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
                
                Spacer()
    
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
