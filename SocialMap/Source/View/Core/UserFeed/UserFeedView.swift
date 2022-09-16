import SwiftUI
import MapKit

struct UserFeedView: View {
    @StateObject private var controller = UserFeedController()
    
    var body: some View {
        ZStack{
            GeometryReader { (geometry) in
                MapView (
                    landmarks: controller.mockedLandmarks,
                    coordinator: controller.mapViewCoordinator,
                    locationCoordinate: controller.userLocation?.center ?? .init()
                )
                
                ScrollView(.horizontal, showsIndicators: false) {
                    Spacer()
                    HStack {
                        ForEach(UserStory.mocketStories) { story in
                            UserComponentStory(image: story.image, name: story.identifier)
//                                .onTapGesture {
//                                    region.center = CLLocationCoordinate2D (
//                                        latitude: story.location.latitude,
//                                        longitude: story.location.longitude
//                                    )
//                                }
                        }
                        
                    }
                    .frame(minWidth: CGFloat(UserStory.mocketStories.count) * (geometry.size.width / 4), alignment: .leading)
                    //.padding(0)
                    //.background { Color.white}
                    //.cornerRadius(10)
                }
                
                
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
}

struct UserFeedView_Previews: PreviewProvider {
    static var previews: some View {
        UserFeedView()
    }
}
