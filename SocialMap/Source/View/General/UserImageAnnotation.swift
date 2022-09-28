import Foundation
import MapKit

class UserImageAnnotation: NSObject, MKAnnotation, Identifiable {
    let id = UUID()
    let title: String?
    let subtitle: String?
    var image: [UIImage]!
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?,
         subtitle: String?,
         image: [UIImage],
         coordinate: CLLocationCoordinate2D) {
            self.title = title
            self.subtitle = subtitle
            self.image = image
            self.coordinate = coordinate
        }
}

extension UserImageAnnotation {
    
    static func requestMockData() -> [UserImageAnnotation] {
        let mockedModelData = UserStory.mocketStories
        var mockedLandMark = [UserImageAnnotation]()
        
        for data in mockedModelData {
            mockedLandMark.append(
                UserImageAnnotation(
                    title: data.identifier,
                    subtitle: "",
                    image: [UIImage (named: data.image) ?? UIImage (systemName: "photo")!] ,
                    coordinate: CLLocationCoordinate2D(
                        latitude: data.location.latitude,
                        longitude: data.location.longitude
                    )
                )
            )
        }
    
        return mockedLandMark
    }
    
}
