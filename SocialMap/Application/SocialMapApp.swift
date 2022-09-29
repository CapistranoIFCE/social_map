import SwiftUI

@main
struct SocialMapApp: App {
    @StateObject var mainViewController = MainViewController()
    
    var body: some Scene {
        WindowGroup {
            MainView(
                controller: mainViewController,
                content: {  UserFeedView(mainViewController: mainViewController) },
                detailsContent: { ImageVisualization(mainViewController: mainViewController) } )
        }
    }
}
