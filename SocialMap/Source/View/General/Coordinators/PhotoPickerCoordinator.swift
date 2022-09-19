import Foundation
import PhotosUI

class PhotoPickerCoordinator: PHPickerViewControllerDelegate {
    private let parent: PhotoPicker
    
    init(_ parent: PhotoPicker) {
        self.parent = parent
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for image in results {
            if image.itemProvider.canLoadObject(ofClass: UIImage.self){
                image.itemProvider.loadObject(ofClass: UIImage.self){ newImage, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    else {
                        DispatchQueue.main.async {
                            self.parent.pickerResult.append(newImage as! UIImage)
                        }
                    }
                }
            } else {
                print("Selected asset is not an image")
            }
        }
        parent.isPresented = false
    }
}
