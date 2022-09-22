import Foundation
import SwiftUI

struct UserComponentStory: View {
    let image: UIImage
    let name: String
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
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
