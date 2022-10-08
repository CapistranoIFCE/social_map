import Foundation
import CoreLocation
import UIKit
import MapKit
import PhotosUI
import Lottie
import SwiftUI

class UserFeedController: NSObject, ObservableObject {
    @Published var userLocation: MKCoordinateRegion?
    @Published var landMarks = [UserImageAnnotation]()
    @Published var isPhotoPickerPresented: Bool = false
    @Published var isAlertPresented: Bool = false
    @Published var pulseOrigin = CGPoint(x: 0.0, y: 0.0)
    @Published var onHold = false
    @Published var currentLandmark: UserImageAnnotation? = nil
    @Published var addPhotoPin = false
    @Published var currentPinPosition: CGPoint = CGPoint(
        x: UIScreen.main.bounds.width * 0.5,
        y: UIScreen.main.bounds.height * 0.5
    )

    let locationManager = LocationManager()
    let photoPickerManager = PhotoPickerManager()
    let animationView = AnimationView()
    var mapViewCoordinator: MapViewCoordinator!
    
    var shouldCallPhotoPicker = false
    var holdTime = 0
    
    override init() {
        super.init()
        self.mapViewCoordinator = MapViewCoordinator()
        self.mapViewCoordinator.viewControllerDelegate = self
    }

    func goToImage(on side: DeviceSide) {
        if userLocation != nil {
            let nearestLandmark = findNearLandmark(
                on: side,
                in: landMarks,
                by: currentLandmark?.coordinate ?? userLocation!.center
            )
            changeCurrentLandmark(to: nearestLandmark)
        }
    }
    
    func initLocation() {
        locationManager.manager = CLLocationManager()
        locationManager.manager?.delegate = self
        if let currentLocation = locationManager.getCurrentLocation() {
            userLocation = MKCoordinateRegion(
                center: currentLocation.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.05,
                    longitudeDelta: 0.05
                )
            )
        }
    }
    
    func deleteAnnotation(_ annotation: UserImageAnnotation) {
        withAnimation(.easeOut) {
            self.landMarks.removeAll(where: { $0.image == annotation.image })
            self.mapViewCoordinator.mapViewInstance?.removeAnnotation(annotation)
        }
    }
    
    func addPinAsAnnotation() {
        guard let mapViewInstance = self.mapViewCoordinator.mapViewInstance else { return }
        
        let pinPositionAsCoordinate = mapViewInstance.convert(
            self.currentPinPosition,
            toCoordinateFrom: mapViewInstance
        )
        
        let locationObject = Location(
            latitude: pinPositionAsCoordinate.latitude,
            longitude: pinPositionAsCoordinate.longitude
        )

        shouldCallPhotoPicker = true
        self.callPhotoPicker(at: locationObject, in: mapViewInstance)
    }
    
    private func addPlaceholderPin(on mapView: MKMapView, in location: CLLocationCoordinate2D) {
        let placeHolder = UserImageAnnotation.annotationPlaceholder(on: location)
        
        self.changeCurrentLandmark(to: placeHolder)
        landMarks.append(placeHolder)
        mapView.addAnnotation(placeHolder)
    }
    
    
    private func removePlaceholderPin(on mapView: MKMapView, placeholderPin: UserImageAnnotation) {
        mapView.removeAnnotation(placeholderPin)
        self.landMarks.removeLast()
    }
    
    func photoPickerHasBeingDismiss(_ pickedImages: [UIImage]) {
        guard let placeholderPin = landMarks.last else { return }
        guard let mapViewInstance = self.mapViewCoordinator.mapViewInstance else { return }
        
        DispatchQueue.main.async {
            self.removePlaceholderPin(on: mapViewInstance, placeholderPin: placeholderPin)
                    
            if !pickedImages.isEmpty {
                let placeholderCoordinate = placeholderPin.coordinate
                
                let newAnnotation = UserImageAnnotation(
                    title: "",
                    subtitle: "",
                    image: pickedImages,
                    coordinate: placeholderCoordinate
                )
                
                withAnimation(.spring()) {
                    self.landMarks.insert(newAnnotation, at: 0)
                }
                
                self.changeCurrentLandmark(to: newAnnotation)
                mapViewInstance.addAnnotation(newAnnotation)
            }
        }
        
        
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
    
    func callPhotoPicker(at location: Location, in mapView: MKMapView) {
        if shouldCallPhotoPicker {
            self.photoPickerManager.checkPhotoPickerPermission { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.addPlaceholderPin (
                            on: mapView, in: CLLocationCoordinate2D (
                                latitude: location.latitude,
                                longitude: location.longitude
                            )
                        )
                        self.isPhotoPickerPresented.toggle()
                    }
                }
            }
        }
        self.holdTime = 0
        self.onHold = false
        self.shouldCallPhotoPicker = false
    }
}

extension UserFeedController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        self.initLocation( )
    }
}

extension UserFeedController: UserFeedControllerDelegate {
    
    func didTapOnMap(at point: CGPoint, in mapView: MKMapView) {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        withAnimation(.spring().speed(0.05)) { self.onHold = true }
        self.pulseOrigin = point
        self.startTimer()
    }
    
    func didLongPressOnMap(at location: Location, in mapView: MKMapView) {
        self.callPhotoPicker(at: location, in: mapView)
    }
    
    func changeCurrentLandmark(to newLandmark: UserImageAnnotation?) {
        self.currentLandmark = newLandmark
        self.userLocation?.center = newLandmark?.coordinate ??
        locationManager.manager?.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        
        guard let mapViewInstance = self.mapViewCoordinator.mapViewInstance else { return }
        guard let annotation = newLandmark else { return }
        mapViewInstance.selectAnnotation(annotation, animated: false)
    }
    
    func showDeleteAlert() {
        self.isAlertPresented = true
    }
}

