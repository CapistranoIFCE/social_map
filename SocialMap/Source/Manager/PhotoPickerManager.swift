import Foundation
import PhotosUI

class PhotoPickerManager {
    var configuration: PHPickerConfiguration{
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 0
        
        return  config
    }
    
    func checkPhotoPickerPermission(completionHandler: @escaping (PHAuthorizationStatus) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
            case .authorized:
                completionHandler(.authorized)
                print("Access is granted by user")
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({
                    (newStatus) in
                        completionHandler(newStatus)
                })
                print("It is not determined until now")
            case .restricted:
                completionHandler(.restricted)
                break
            case .denied:
                completionHandler(.denied)
                break
            case .limited:
                completionHandler(.limited)
                break
        @unknown default:
            break
        }
    }
    
}
