import SwiftUI


class ImageVisualizationController: ObservableObject {
    @Published var annotation: UserImageAnnotation?
    
    func getIndex(imageAnnotation: UIImage) ->Int{
        let index = annotation?.image.firstIndex(where: { $0 == imageAnnotation }) ?? 0
        return index
    }
}
