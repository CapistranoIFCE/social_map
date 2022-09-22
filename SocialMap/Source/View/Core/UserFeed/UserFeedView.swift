import SwiftUI
import MapKit
import PhotosUI


struct UserFeedView: View {
    @StateObject private var controller = UserFeedController()
    
    var body: some View {
        NavigationView{
            GeometryReader { (geometry) in
                VStack {
                    MapView (
                        landmarks: controller.mockedLandmarks,
                        coordinator: controller.mapViewCoordinator,
                        locationCoordinate: controller.userLocation?.center ?? .init(),
                        onLongPress: controller.callPhotoPicker,
                        oneClickCallback: controller.startAnimation
                    )
                    
                    VStack(alignment: .leading){
                        Text("Albuns de Davi")
                            .font(.system(size: 20))
                            .bold()
                            .padding()
                        
                        HStack{
                            ScrollView(.horizontal, showsIndicators: false) {
                                Spacer()
                                HStack {
                                    ForEach(controller.mockedLandmarks) { story in
                                        UserComponentStory (
                                            image: story.image,
                                            name: story.title ?? "Untitle")
                                            .onTapGesture {
                                                controller.userLocation?.center = story.coordinate
                                            }
                                    }
                                    
                                }
                            }
                            .frame(height: geometry.size.height * 0.070)
                        }
                    }
                }
                
                LottieView(
                    lottieFile: "pulse",
                    animationView: controller.animationView
                )
                .frame(width: 300, height: 300)
                .position(controller.pulseOrigin)
                .opacity(controller.onHold ? 1 : 0)
                
                
                HStack {
                    Rectangle()
                        .frame (
                            width: geometry.size.width * 0.1,
                            height: geometry.size.height -
                            geometry.size.height * 0.070
                        )
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
                        .frame (
                            width: geometry.size.width * 0.1,
                            height: geometry.size.height -
                            geometry.size.height * 0.070
                        )
                        .onTapGesture(count: 2, perform: {
                            controller.goToNextImage()
                            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        })
                        .onTapGesture {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                        .foregroundColor(.blue.opacity(0.00001))
                }
                .sheet(isPresented: $controller.isPresented) {
                            PhotoPicker(
                                configuration: controller.config,
                                photoPickerDismissCallBack: controller.photoPickerHasBeingDismiss,
                                isPresented: $controller.isPresented
                            )
                        }
            }
            .edgesIgnoringSafeArea(.top)
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
