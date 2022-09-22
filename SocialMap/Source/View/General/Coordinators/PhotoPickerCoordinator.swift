import Foundation
import PhotosUI

class PhotoPickerCoordinator: PHPickerViewControllerDelegate {
    
    private let parent: PhotoPicker
    
    init(_ parent: PhotoPicker) {
        self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        Task {
            var resultImages = [UIImage]()
            for image in results {
                if image.itemProvider.canLoadObject(ofClass: UIImage.self){
                    image.itemProvider.loadObject(ofClass: UIImage.self){ newImage, error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        else {
                            resultImages.append( newImage as! UIImage)
                            if resultImages.count == results.count {
                                    self.parent.photoPickerDismissCallBack(resultImages)
                                }
                            
                        }
                    }
                } else {
                    print("Selected asset is not an image")
                }
            }
        }
        parent.isPresented = false
    }
}
