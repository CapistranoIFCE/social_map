import SwiftUI
import MapKit
import PhotosUI


struct UserFeedView: View {
    @StateObject var mainViewController: MainViewController
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
                        Text("David's Albums")
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
                                            name: story.title ?? "Untitle",
                                            focused: story == controller.currentLandmark
                                        ).onTapGesture {
                                            controller.changeCurrentLandmark(to: story)
                                        }
                                    }
                                    
                                }
                            }
                            .frame(height: geometry.size.height * 0.12)
                        }
                    }
                }
                
                Button("Tap me"){
                    mainViewController.selectedAnnotation = controller.mockedLandmarks.first
                    mainViewController.isShowing.toggle()
                }.position(x: 300, y: 300)
                
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
                            geometry.size.height * 0.12
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
                            geometry.size.height * 0.12
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
