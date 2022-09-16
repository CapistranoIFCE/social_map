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
    
    func callPhotoPicker(_ location: Location) {
        print("Do SwiftUI: \(location.latitude) e \(location.longitude)")
        isPresented.toggle()
    }
    
    func startAnimation(_ point: CGPoint) {
        print(" one click at \(point)")
    }
    
    var body: some View {
        NavigationView{
            GeometryReader { (geometry) in
                MapView (
                    landmarks: controller.mockedLandmarks,
                    coordinator: controller.mapViewCoordinator,
                    locationCoordinate: controller.userLocation?.center ?? .init(),
                    onLongPress: callPhotoPicker,
                    oneClickCallback: startAnimation
                    
                )
                
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
            .toolbar {
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
