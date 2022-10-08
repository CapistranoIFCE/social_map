import UIKit
import Foundation
import MapKit

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    weak var mapViewInstance: MKMapView?
    weak var viewControllerDelegate: UserFeedControllerDelegate?
    
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
        
        viewControllerDelegate?.changeCurrentLandmark(to: annotation)
        annotationView.openAlbum()
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let annotationView = view as? CustomAnnotationView else { return }
        annotationView.superview?.layoutIfNeeded()
        annotationView.closeAlbum()
    }
    
    @objc func handleLongTapGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        let uiView = gestureRecognizer.view as! MKMapView
        
        if gestureRecognizer.state == .began {
            let touchLocation = gestureRecognizer.location(in: uiView)
            viewControllerDelegate?.didTapOnMap(at: touchLocation, in: uiView)
            return
        }
        
        if gestureRecognizer.state == UIGestureRecognizer.State.ended {
            let touchLocation = gestureRecognizer.location(in: uiView)
            let locationCoordinate = uiView.convert(touchLocation, toCoordinateFrom: uiView)
            let locationObject = Location(
                latitude: locationCoordinate.latitude,
                longitude: locationCoordinate.longitude
            )
            
            viewControllerDelegate?.didLongPressOnMap(at: locationObject, in: uiView)
        }
        
    }
}

extension MapViewCoordinator : UIContextMenuInteractionDelegate {

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        guard let annotationView = interaction.view as? MKAnnotationView else { return nil }
        guard let annotation = annotationView.annotation as? UserImageAnnotation else { return nil }

        return UIContextMenuConfiguration(
            identifier: "\(annotation.id)" as NSCopying, previewProvider: nil
        ) { _ in
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.viewControllerDelegate?.changeCurrentLandmark(to: annotation)
                self.viewControllerDelegate?.showDeleteAlert()
            }
                                    
            return UIMenu (
                title: annotation.title ?? "",
                image: nil, identifier: nil,
                options: [],
                children: [delete]
            )
        }
    }
}
