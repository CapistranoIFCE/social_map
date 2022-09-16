//
//  UserComponentStory.swift
//  SocialMap
//
//  Created by Raina Rodrigues de Lima on 15/09/22.
//

import Foundation
import SwiftUI

struct UserComponentStory: View {
    let image: String
    let name: String
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 84, height: 84)
                .clipShape(Capsule())
                .shadow(color: .black, radius: 5, x: 0.8, y: 0.8)
            
            Text(name)
                .font(.caption)
                .bold()
                .multilineTextAlignment(.center)
                .lineLimit(1)
        }
        .padding()
    }
}
