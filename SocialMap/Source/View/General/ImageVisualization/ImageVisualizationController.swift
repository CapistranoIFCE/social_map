import SwiftUI


class ImageVisualizationController: ObservableObject {
    @Published var annotation: UserImageAnnotation?
    
    init(annotation: UserImageAnnotation? = nil) {
        self.annotation = annotation
    }
    
    func getIndex(imageAnnotation: UIImage) ->Int{
        let index = annotation?.images.firstIndex(where: { $0 == imageAnnotation }) ?? 0
        return index
    }
}
