import Foundation
import MapKit

struct PhotoPickerResult: Identifiable {
    let id = UUID()
    let image: UIImage
    let index: Int
}

class CustomAnnotationView: MKAnnotationView {
    var images: [UIImage] = []
    
    fileprivate var image03TopConstraint: NSLayoutConstraint!
    fileprivate var image02TopConstraint: NSLayoutConstraint!
    fileprivate var image01TopConstraint: NSLayoutConstraint!
    
    let image01: UIImageView = {
        let image1 = UIImageView()
        image1.contentMode = .scaleAspectFill
        image1.tintColor = .black
        image1.translatesAutoresizingMaskIntoConstraints = false
        return image1
    }()
    
    let image02: UIImageView = {
        let image2 = UIImageView()
        image2.contentMode = .scaleAspectFill
        image2.tintColor = .black
        image2.translatesAutoresizingMaskIntoConstraints = false
        return image2
    }()
    
    let image03: UIImageView = {
        let image3 = UIImageView()
        image3.contentMode = .scaleAspectFill
        image3.tintColor = .black
        image3.translatesAutoresizingMaskIntoConstraints = false
        return image3
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.addSubview(image01)
        self.addSubview(image02)
        self.addSubview(image03)
        
        self.configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureConstraints() {
        image03TopConstraint = self.topAnchor.constraint(equalTo: self.topAnchor, constant: 45)
        image02TopConstraint = image03.topAnchor.constraint(equalTo: self.topAnchor, constant: 30)
        image01TopConstraint = image03.topAnchor.constraint(equalTo: self.topAnchor, constant: 15)
        
        image02TopConstraint.isActive = true
        image01TopConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            image01.topAnchor.constraint(
                equalTo: image03.topAnchor,
                constant: image01TopConstraint.constant
            ),
            
            image01.centerXAnchor.constraint(equalTo: image03.centerXAnchor),
            image01.widthAnchor.constraint(equalToConstant: 60),
            image01.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        NSLayoutConstraint.activate([
            image02.topAnchor.constraint(
                equalTo: image03.topAnchor,
                constant: image02TopConstraint.constant
            ),
            
            image02.centerXAnchor.constraint(equalTo: image03.centerXAnchor),
            image02.widthAnchor.constraint(equalToConstant: 85),
            image02.heightAnchor.constraint(equalToConstant: 85),
        ])
        
        NSLayoutConstraint.activate([
            image03.topAnchor.constraint(equalTo: self.topAnchor, constant: image03TopConstraint.constant),
            image03.widthAnchor.constraint(equalToConstant: 100),
            image03.heightAnchor.constraint(equalToConstant: 100)
        ])
        
    }
    
    func closeAlbum() {
        UIView.animate(withDuration: 1.0) {
            self.image01TopConstraint.constant = 0
            self.image02TopConstraint.constant = 35
            self.image03TopConstraint.constant = 45
            self.layoutIfNeeded()
        }
    }
    
    func openAlbum() {
        UIView.animate(withDuration: 1.0) {
            self.image01TopConstraint.constant = 0
            self.image02TopConstraint.constant = 70
            self.image03TopConstraint.constant = 100
            self.layoutIfNeeded()
        }
    }
}

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    weak var mapViewInstance: MKMapView?
    
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
            //            annotationView.canShowCallout = true
            
            return annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotationView = view as? CustomAnnotationView else { return }
        annotationView.superview?.layoutIfNeeded()
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
