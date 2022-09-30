import Foundation
import SwiftUI

struct UserComponentStory: View {
    let image: [UIImage]
    let name: String
    let focused: Bool
    private let circleWidth = UIScreen.main.bounds.width * 0.13
    
    var body: some View {
        VStack {
            Circle()
                .frame(width: 68, height: 68)
                .foregroundColor(focused ? Color("AccentColor") : .clear)
                .overlay(
                    Image(uiImage: image.first!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                        .clipShape(Capsule())
                        .overlay(
                            alignment: .bottomTrailing,
                            content: {
                                Circle()
                                    .frame(width: 18, height: 18)
                                    .overlay(
                                        Text("\(image.count)")
                                            .font(.caption)
                                            .foregroundColor(.black)
                                    )
                                    .foregroundColor(Color("AccentColor"))
                            }
                        )
                )

            
            Text(name)
                .font(.caption)
                .bold()
                .multilineTextAlignment(.center)
                .lineLimit(1)
        }
        .frame(width: circleWidth, height: 64)
        .padding([.trailing, .leading], 12)
    }
}
