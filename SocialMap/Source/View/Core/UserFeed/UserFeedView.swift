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
                                    ForEach(UserStory.mocketStories) { story in
                                        UserComponentStory(image: story.image, name: story.identifier)
                                            .onTapGesture {
                                                controller.userLocation?.center = CLLocationCoordinate2D (
                                                    latitude: story.location.latitude,
                                                    longitude: story.location.longitude
                                                )
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
                 .toolbar {
                    ToolbarItem {
                        Button(action: {
                            controller.isPresented.toggle()
                        }) {
                            Image(systemName: "photo.circle.fill").scaleEffect(x: 2, y: 2)
                                .buttonStyle(.borderedProminent)
                                .controlSize(.regular)
                        }.sheet(isPresented: $controller.isPresented) {
                            PhotoPicker(
                                configuration: controller.config,
                                pickerResult: $controller.pickerResult,
                                isPresented: $controller.isPresented
                            )
                        }
                        .frame(minWidth: CGFloat(UserStory.mocketStories.count) * (geometry.size.width / 4), alignment: .leading)
                    }
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
