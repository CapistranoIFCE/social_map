import Foundation
import SwiftUI

class MainViewController: ObservableObject {
    @Published var isShowing: Bool = false
    var selectedAnnotation: UserImageAnnotation?
}
