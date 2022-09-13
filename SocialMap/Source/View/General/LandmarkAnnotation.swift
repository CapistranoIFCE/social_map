import Foundation
import MapKit

class LandmarkAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?,
         subtitle: String?,
         coordinate: CLLocationCoordinate2D) {
            self.title = title
            self.subtitle = subtitle
            self.coordinate = coordinate
        }
}

extension LandmarkAnnotation {
    
    static func requestMockData() -> [LandmarkAnnotation] {
        let mockedModelData = UserStory.mocketStories
        var mockedLandMark = [LandmarkAnnotation]()
        for data in mockedModelData {
            mockedLandMark.append(
                LandmarkAnnotation(
                    title: data.identifier,
                    subtitle: "",
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
