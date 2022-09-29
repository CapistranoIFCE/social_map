import SwiftUI
import MapKit
import PhotosUI


struct UserFeedView: View {
    @StateObject private var controller = UserFeedController()
    
    var body: some View {
        NavigationView{
            GeometryReader { (geometry) in
                VStack {
                    ZStack {
                        MapView (
                            landmarks: controller.mockedLandmarks,
                            coordinator: controller.mapViewCoordinator,
                            locationCoordinate: controller.userLocation?.center ?? .init(),
                            onLongPress: controller.callPhotoPicker,
                            oneClickCallback: controller.startAnimation
                        )
                        
                        Image(systemName: "photo.on.rectangle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 46, height: 46)
                            .position(controller.currentPinPosition)
                            .opacity(controller.addPhotoPin ? 1 : 0)
                            .shadow(
                                color: .black,
                                radius: controller.addPhotoPin ? 10 : 0,
                                x: 0.5, y: 1.5
                            )
                    }
                    
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
                                            image: story.image.last!,
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
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            if controller.addPhotoPin {
                                controller.addPinAsAnnotation()
                            }
                            controller.addPhotoPin.toggle()
                        } label: {
                            if controller.addPhotoPin {
                                Text("Done")
                            } else {
                                Image(systemName: "plus")
                            }
                        }
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
