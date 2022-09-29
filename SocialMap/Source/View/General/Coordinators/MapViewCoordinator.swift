import UIKit
import Foundation
import MapKit


class MapViewCoordinator: NSObject, MKMapViewDelegate {
    weak var mapViewInstance: MKMapView?
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        if let annotation = annotation as? UserImageAnnotation {
            let annotationView = MKAnnotationView()
            let annotationFrame = CGSize(width: 64, height: 48)
            let annotationImage = annotation.image.resizeImageTo (
                size: CGSize(width: 84, height: 64)
            )?.withRoundedCorners(radius: 20)
            
            annotationView.frame.size = annotationFrame
            annotationView.image = annotationImage
            annotationView.layer.cornerRadius = 20
            annotationView.contentMode = .scaleAspectFit
            annotationView.canShowCallout = true
            
            let interaction = UIContextMenuInteraction(delegate: self)
            
            annotationView.addInteraction(interaction)
            
            // cria o botao INFO
//            let btn = UIButton(type: .detailDisclosure)
//            annotationView.rightCalloutAccessoryView = btn
            
            
//            let FirstAction = UIAction(title: "First Action"),
//                handler: {_ in
//                    print("First action")
//                })
//            
//            let secondAction = UIAction(title: "Second Action",
//                                        handler: {_ in
//                print("Second action")
//            })
            
//            let button = UIButton(type: .detailDisclosure)
//            button.menu = UIMenu(title: "My Title")
//            button.showsMenuAsPrimaryAction = true
//            annotationView.canShowCallout = true
//            annotationView.rightCalloutAccessoryView = button
            
            
            return annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
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

// MARK: - CONTEXT MENU
extension MapViewCoordinator : UIContextMenuInteractionDelegate {

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        guard let annotationView = interaction.view as? MKAnnotationView else {
            return nil
        }

        guard let annotation = annotationView.annotation as? UserImageAnnotation else {
            return nil
        }

        return UIContextMenuConfiguration(identifier: "\(annotation.id)" as NSCopying, previewProvider: nil) { _ in
            
            let favorite = UIAction(title: "Edit title", image: UIImage(systemName: "pencil")) { _ in
                print("Edit")
            }
            let share = UIAction(title: "Delete photo", image: UIImage(systemName: "trash")) { _ in
                print("Delete")
                self.mapViewInstance?.removeAnnotation(annotation)
            }
            
            return UIMenu(title: annotation.title ?? "", image: nil, identifier: nil, options: [], children: [favorite, share])
            
        }
    }
    


}
