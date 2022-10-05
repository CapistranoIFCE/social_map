import PhotosUI
import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = PHPickerViewController
    
    let configuration: PHPickerConfiguration
    let photoPickerDismissCallBack: (_ pickedImages: [UIImage]) -> Void
    
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }
    
    func makeCoordinator() -> PhotoPickerCoordinator {
        PhotoPickerCoordinator(self)
    }
}
