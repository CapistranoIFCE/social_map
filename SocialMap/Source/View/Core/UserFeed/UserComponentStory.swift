import Foundation
import SwiftUI

struct UserComponentStory: View {
    let image: UIImage
    let name: String
    let focused: Bool
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: focused ? 84: 64, height: focused ? 84: 64)
                .clipShape(Capsule())
            
            Text(name)
                .font(.caption)
                .bold()
                .multilineTextAlignment(.center)
                .lineLimit(1)
        }
        .padding()
    }
}
