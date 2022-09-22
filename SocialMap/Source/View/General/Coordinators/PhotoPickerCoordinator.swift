import Foundation
import PhotosUI

class PhotoPickerCoordinator: PHPickerViewControllerDelegate {
    
    private let parent: PhotoPicker
    
    init(_ parent: PhotoPicker) {
        self.parent = parent
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        Task {
            var imageResults = [UIImage]()
            for image in results {
                let provider = image.itemProvider
                
                guard let url = try await provider.loadItem(forTypeIdentifier: "public ima") as? URL else {
                    return
                }
                
                let data = try Data(contentsOf: url)
                print(data)
                if let image = UIImage(data: data) {
                    imageResults.append(image)
                }
            }
            print(imageResults.count)
            parent.photoPickerDismissCallBack(imageResults)
        }
        parent.isPresented = false
    }
    
    
}
