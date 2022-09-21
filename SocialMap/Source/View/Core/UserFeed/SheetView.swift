
import SwiftUI
import MapKit

struct SheetView: View {
    
    
    //guardar infor da tela scroll
    @State var offset: CGFloat = 0
    @State var translation : CGSize = CGSize(width: 0, height: 0)
    @State var location : CGPoint = CGPoint(x: 0, y: 0)
    
    var body: some View{
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            Color.red
            
            GeometryReader{ reader in
                BottomSheet()
                // a altura da sheet fixa
                    .offset(y: reader.frame(in: .global).height - 60)
                    .offset(y: offset)
                    .gesture(DragGesture().onChanged({(value) in
                        translation = value.translation
                        location = value.location
                        
                        if value.startLocation.y > reader.frame(in: .global).midX{
                            if value.translation.height < 0 && offset > (-reader.frame(in: .global).height + 140){
                                offset = value.translation.height
                            }
                        }
                        
                        if value.startLocation.y < reader.frame(in: .global).midX{
                            if value.translation.height > 0 && offset < 0{
                                offset = (-reader.frame(in: .global).height + 140) + value.translation.height
                            }
                        }
                    }).onEnded({(value) in
                        withAnimation{
                            if value.startLocation.y > reader.frame(in: .global).midX{
                                if -value.translation.height > reader.frame(in: .global).midX{
                                    offset = (-reader.frame(in: .global).height/3 + 115)
                                    return
                                }
                                offset = 0
                            }
                            
                            if value.startLocation.y > reader.frame(in: .global).midX{
                                if value.translation.height < reader.frame(in: .global).midX{
                                    offset = (-reader.frame(in: .global).height/3 + 115)
                                    return
                                }
                            }
                        }
                    }))
            }
            
        }
    }
    
    
    struct BottomSheet: View{
        
        @StateObject private var controller = UserFeedController()
        
        @State var text = ""
        var body: some View{
            VStack{
                Capsule()
                    .fill(Color(white: 0.95))
                    .frame(width: 50, height: 5)
                
                HStack {
                    Text("Álbuns de Davi")
                        .font(.system(size: 20))
                        .bold()
                        .padding()
                        .foregroundColor(.black)
                    Spacer()
                }
                
                HStack(){
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(UserStory.mocketStories) { story in
                                UserComponentStory(image: story.image, name: story.identifier)
                                    .onTapGesture {
                                        controller.userLocation?.center = CLLocationCoordinate2D (
                                            latitude: story.location.latitude,
                                            longitude: story.location.longitude
                                        )
                                    }
                            }
                
                        }
                        Spacer()
                    }
                    //.frame(height: geometry.size.height * 0.125)
                }
            }
            .padding(.horizontal,10)
            .padding(.bottom,20)
            .padding(.top, 15)
            .background(BlurShape())
s        }
    }
    
    struct BlurShape: UIViewRepresentable {
        func makeUIView(context: Context) -> UIVisualEffectView{
            return UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        }
        func updateUIView(_ uiView: UIViewType, context: Context) {
            //
        }
    }
    
    struct SheetView_Previews: PreviewProvider{
        static var previews: some View{
            SheetView()
        }
    }
}
