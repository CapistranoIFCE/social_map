import UIKit
import Foundation
import MapKit

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    private var title: String = "Delete"
    weak var mapViewInstance: MKMapView?
    weak var controllerInstance: UserFeedController?
   
    init(controllerInstance: UserFeedController? = nil) {
        self.controllerInstance = controllerInstance
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        if let annotation = annotation as? UserImageAnnotation {
            let annotationView = CustomAnnotationView()
            let annotationFrame = CGSize(width: 64, height: 48)
            
            for (index, image) in annotation.image.enumerated() {
                if index == 0 {
                    annotationView.image03.image = image
                }
                if index == 1 {
                    annotationView.image02.image = image
                }
                if index == 2 {
                    annotationView.image01.image = image
                }
            }
            
            annotationView.frame.size = annotationFrame
            annotationView.layer.cornerRadius = 20
            annotationView.contentMode = .scaleAspectFit
            
            let interaction = UIContextMenuInteraction(delegate: self)
            annotationView.addInteraction(interaction)
            
            return annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotationView = view as? CustomAnnotationView else { return }
        guard let annotation = annotationView.annotation as? UserImageAnnotation else { return }
        guard let controllerInstance = controllerInstance else { return }
        
        controllerInstance.changeCurrentLandmark(to: annotation)
        annotationView.openAlbum()
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let annotationView = view as? CustomAnnotationView else { return }
        annotationView.superview?.layoutIfNeeded()
        annotationView.closeAlbum()
    }
    
    @objc func handleLongTapGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        guard let gesture = gestureRecognizer as? CustomGestureRecognizer else { return }
        let uiView = gestureRecognizer.view as! MKMapView
        
        if gestureRecognizer.state == .began {
            let touchLocation = gestureRecognizer.location(in: uiView)
            gesture.oneClickCallback!(touchLocation, uiView)
            return
        }
        
        if gestureRecognizer.state == UIGestureRecognizer.State.ended {
            let touchLocation = gestureRecognizer.location(in: uiView)
            let locationCoordinate = uiView.convert(touchLocation, toCoordinateFrom: uiView)
            
            gesture.longPressCallback!(
                Location(
                    latitude: locationCoordinate.latitude,
                    longitude: locationCoordinate.longitude
                ),
                uiView
            )
        }
        
    }
}

extension MapViewCoordinator : UIContextMenuInteractionDelegate {

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        guard let annotationView = interaction.view as? MKAnnotationView else {
            return nil
        }

        guard let annotation = annotationView.annotation as? UserImageAnnotation else {
            return nil
        }

        return UIContextMenuConfiguration(identifier: "\(annotation.id)" as NSCopying, previewProvider: nil) { _ in
            
            let delete = UIAction(title: self.title, image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.controllerInstance?.changeCurrentLandmark(to: annotation)
                self.controllerInstance?.isAlertPresented = true
            }
                                    
            return UIMenu(title: annotation.title ?? "", image: nil, identifier: nil, options: [], children: [delete])
        }
    }
}
