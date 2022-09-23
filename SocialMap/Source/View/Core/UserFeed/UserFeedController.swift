import Foundation
import CoreLocation
import UIKit
import MapKit
import PhotosUI
import Lottie
import SwiftUI

class UserFeedController: NSObject, ObservableObject {
    @Published var userLocation: MKCoordinateRegion?
    @Published var mockedLandmarks = UserImageAnnotation.requestMockData()
    @Published var isPresented: Bool = false
    @Published var pulseOrigin = CGPoint(x: 0.0, y: 0.0)
    @Published var onHold = false
    
    var config: PHPickerConfiguration{
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 0
        
        return  config
    }
    
    let mapViewCoordinator = MapViewCoordinator()
    let animationView = AnimationView()
    var locationManager: CLLocationManager?
    var currentLandmark: UserImageAnnotation? = nil
    var shouldCallPhotoPicker = false
    var holdTime = 0
    
    func goToNextImage() {
        if userLocation != nil {
            let nearestLandmarkRight = findNearLandmark (
                on: DeviceSide.right,
                in: mockedLandmarks,
                by: currentLandmark?.coordinate ?? userLocation!.center
            )
            currentLandmark = nearestLandmarkRight
            userLocation!.center = nearestLandmarkRight?.coordinate ?? locationManager?.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        }
    }
    
    func goToPreviousImage() {
        if userLocation != nil {
            let nearestLandmarkLeft = findNearLandmark (
                on: DeviceSide.left,
                in: mockedLandmarks,
                by: currentLandmark?.coordinate ?? userLocation!.center
            )
            currentLandmark = nearestLandmarkLeft
            userLocation!.center = nearestLandmarkLeft?.coordinate ?? locationManager?.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        }
    }
    
    func photoPickerHasBeingDismiss(_ pickedImages: [UIImage]) {
        guard let placeholderPin = mockedLandmarks.last else { return }
        guard let mapViewInstance = self.mapViewCoordinator.mapViewInstance else { return }
        let placeholderCoordinate = placeholderPin.coordinate

        DispatchQueue.main.async {
            self.removePlaceholderPin(on: mapViewInstance, placeholderPin: placeholderPin)
                    
            if !pickedImages.isEmpty {
                let newAnnotation = UserImageAnnotation(
                    title: "Untitle",
                    subtitle: "",
                    image: pickedImages.last!,
                    coordinate: placeholderCoordinate
                )
                
                withAnimation(.spring()) {
                    self.mockedLandmarks.insert(newAnnotation, at: 0)
                }
                
                self.userLocation?.center = newAnnotation.coordinate
                mapViewInstance.addAnnotation (newAnnotation)
            }
        }
        
        
    }
    
    func callPhotoPicker(_ location: Location, _ mapView: MKMapView) {
        if shouldCallPhotoPicker {
            self.checkPermission { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.addPlaceholderPin (
                            on: mapView, in: CLLocationCoordinate2D (
                                latitude: location.latitude,
                                longitude: location.longitude
                            )
                        )
                        self.isPresented.toggle()
                    }
                }
            }
        }
        self.holdTime = 0
        self.onHold.toggle()
        self.shouldCallPhotoPicker = false
    }
    
    func startAnimation(_ point: CGPoint, _ mapView: MKMapView) {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        withAnimation(.spring().speed(0.05)) { self.onHold.toggle() }
        self.pulseOrigin = point
        self.startTimer()
    }
    
    private func addPlaceholderPin(on mapView: MKMapView, in location: CLLocationCoordinate2D) {
        let placeHolder = UserImageAnnotation(
            title: "",
            subtitle: "",
            coordinate: location
        )
        mockedLandmarks.append(placeHolder)
        mapView.addAnnotation(placeHolder)
    }
    
    
    private func removePlaceholderPin(on mapView: MKMapView, placeholderPin: UserImageAnnotation) {
        mapView.removeAnnotation(placeholderPin)
        self.mockedLandmarks.removeLast()
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if self.onHold {
                self.holdTime += 1
                if self.holdTime == 1 {  UIImpactFeedbackGenerator(style: .heavy).impactOccurred() }
                if self.holdTime >= 1 { self.shouldCallPhotoPicker = true }
                return
            }
            self.holdTime = 0
            timer.invalidate()
        }
    }
    
    func findNearLandmark(on side: DeviceSide, in landmarks: [UserImageAnnotation], by startLocation: CLLocationCoordinate2D) -> UserImageAnnotation? {
        
        func findNearLandmarkRight() -> UserImageAnnotation? {
            var rigthLandmarks = [UserImageAnnotation]()
            
            for landmark in landmarks {
                if landmark.coordinate.longitude > startLocation.longitude {
                    rigthLandmarks.append(landmark)
                }
            }
            
            rigthLandmarks = rigthLandmarks.sorted(by: { $0.coordinate.longitude < $1.coordinate.longitude })
            
            return rigthLandmarks.first
        }
        
        func findNearLandmarkLeft() -> UserImageAnnotation? {
            var leftLandmarks = [UserImageAnnotation]()
            
            for landmark in landmarks {
                if landmark.coordinate.longitude < startLocation.longitude {
                    leftLandmarks.append(landmark)
                }
            }
            
            leftLandmarks = leftLandmarks.sorted(by: { $0.coordinate.longitude > $1.coordinate.longitude })
            
            return leftLandmarks.first
        }
    
        
        return side == DeviceSide.right ? findNearLandmarkRight() : findNearLandmarkLeft()
    }
    
    func checkIfLocationServiceIsEnable() {
        if  CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            checkLocationAuthorization()
        } else {
            // TODO ENVIAR UM ALERTA
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // TODO Avaliar Case
            break
        case .denied:
            // TODO Avaliar Case
            break
        case .authorizedAlways, .authorizedWhenInUse:
            guard let location = locationManager.location else { return }
            userLocation = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.05,
                    longitudeDelta: 0.05
                )
            )
            break
        @unknown default:
            break
        }
    }
    
    func checkPermission(completionHandler: @escaping (PHAuthorizationStatus) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
            case .authorized:
                completionHandler(.authorized)
                print("Access is granted by user")
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({
                    (newStatus) in
                        completionHandler(newStatus)
                })
                print("It is not determined until now")
            case .restricted:
                completionHandler(.restricted)
                break
            case .denied:
                completionHandler(.denied)
                break
            case .limited:
                completionHandler(.limited)
                break
        @unknown default:
            break
        }
    }
}

extension UserFeedController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.checkLocationAuthorization()
    }
}

