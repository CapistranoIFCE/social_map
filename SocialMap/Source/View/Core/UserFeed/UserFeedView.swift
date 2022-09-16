import SwiftUI
import MapKit
import PhotosUI

struct UserFeedView: View {
    @StateObject private var controller = UserFeedController()
    @State private var isPresented: Bool = false
    @State private var pickerResult: [UIImage] = []
    
    
    var config: PHPickerConfiguration{
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 0
        
        return  config
    }
    
    var body: some View {
        NavigationView{
            GeometryReader { (geometry) in
                VStack {
                    MapView (
                        landmarks: controller.mockedLandmarks,
                        coordinator: controller.mapViewCoordinator,
                        locationCoordinate: controller.userLocation?.center ?? .init()
                    )

                    VStack(alignment: .leading){
                        Text("Albuns de Davi")
                            .font(.system(size: 24))
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
                            .frame(height: geometry.size.height * 0.125)
                        }
                    }
                }


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
                }.toolbar {
                    ToolbarItem {
                        Button(action: {
                            isPresented.toggle()
                        }) {
                            Image(systemName: "photo.circle.fill").scaleEffect(x: 2, y: 2)
                                .buttonStyle(.borderedProminent)
                                .controlSize(.regular)
                        }.sheet(isPresented: $isPresented) {
                            PhotoPicker(configuration: self.config, pickerResult: $pickerResult, isPresented: $isPresented)
                        }
                        .frame(minWidth: CGFloat(UserStory.mocketStories.count) * (geometry.size.width / 4), alignment: .leading)
                        //.padding(0)
                        //.background { Color.white}
                        //.cornerRadius(10)
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
