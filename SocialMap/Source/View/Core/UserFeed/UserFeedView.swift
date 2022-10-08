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
                            landmarks: controller.landMarks,
                            coordinator: controller.mapViewCoordinator,
                            locationCoordinate: controller.userLocation?.center ?? .init()
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
                        Text(
                            !controller.landMarks.isEmpty ?
                            "Your's Albums" : "No Albums Yet")
                            .font(.system(size: 20))
                            .bold()
                            .padding()
                        
                        HStack{
                            if controller.landMarks.isEmpty {
                                Text("Add your first album!")
                                    .font(.body)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    Spacer()
                                    HStack {
                                        ForEach(controller.landMarks) { story in
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
                                .padding([.leading], 12)
                                .frame(height: geometry.size.height * 0.12)
                            }
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
                            controller.goToImage(on: .left)
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
                            controller.goToImage(on: .right)
                            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        })
                        .onTapGesture {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                        .foregroundColor(.blue.opacity(0.00001))
                }
                .alert(isPresented: $controller.isAlertPresented) {
                    Alert(
                        title: Text(controller.currentLandmark?.title ?? ""),
                        message: Text("Are you sure that you want to delete this album?"),
                        primaryButton: .cancel(),
                        secondaryButton: .destructive(Text("Delete")) {
                            controller.deleteAnnotation(controller.currentLandmark!)
                        }
                    )
                }
                .sheet(isPresented: $controller.isPhotoPickerPresented) {
                            PhotoPicker(
                                configuration: controller.photoPickerManager.configuration,
                                photoPickerDismissCallBack: controller.photoPickerHasBeingDismiss,
                                isPresented: $controller.isPhotoPickerPresented
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
                                    .font(.caption)
                                    .padding(6)
                                    .foregroundColor(.black)
                                    .background(Color("AccentColor"))
                                    .cornerRadius(8)
                            } else {
                                Image(
                                    systemName: "plus.rectangle.fill.on.rectangle.fill"
                                )
                            }
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            .onAppear {
//                controller.mapViewCoordinator.controllerInstance = controller
                controller.initLocation()
            }
        }
    }
}
