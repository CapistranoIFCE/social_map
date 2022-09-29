import SwiftUI

struct MainView<Content: View, DetailsContent: View>: View {
    let controller: MainViewController
    @ViewBuilder let content: () -> Content
    @ViewBuilder let detailsContent: () -> DetailsContent
    
    var body: some View {
        Group {
            if controller.isShowing {
                ZStack { content().blur(radius: controller.isShowing ? 5.0 : 0.0); detailsContent() } }
            else { content() }
        }
        .animation(.default, value: controller.isShowing)
        
    }
}
