
import Foundation
import UIKit

class CustomGestureRecognizer : UILongPressGestureRecognizer {
    
    var longPressCallback: ((_ location: Location) -> Void)?
    
    
}
