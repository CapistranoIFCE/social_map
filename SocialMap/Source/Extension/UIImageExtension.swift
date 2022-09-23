import Foundation
import UIKit

extension UIImage {
    
    func resizeImageTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func merge(mergewith:UIImage) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            let actualArea = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let mergeArea = CGRect(x: 0, y: size.height - mergewith.size.height, width: size.width, height: mergewith.size.height)
            self.draw(in: actualArea)
            mergewith.draw(in: mergeArea)
            let merged = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return merged
        }
    
    
}
