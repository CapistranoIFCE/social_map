import SwiftUI

struct StackCardView: View {
    @EnvironmentObject var imageVisualizationControlller: ImageVisualizationController
    @GestureState var isDraggin: Bool = false
    @State var offset: CGFloat = 0
    @State var endSwipe: Bool = false
    var imageAnnotation: UIImage
    
    var body: some View {
        GeometryReader{ proxy in
            let size = proxy.size
            let index = CGFloat(imageVisualizationControlller.getIndex(imageAnnotation: imageAnnotation))
            let topOffset = (index <= 2 ? index : 2) * 15

            ZStack{
                
                Image(uiImage: imageAnnotation)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width - topOffset, height: size.height)
                    .cornerRadius(15)
                    .offset(y: -topOffset)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .offset(x: offset)
        .rotationEffect(.init(degrees: getRotation(angle: 8)))
        .contentShape(Rectangle().trim(from: 0, to: endSwipe ? 0 : 1))
        .gesture(
        
        DragGesture()
            .updating($isDraggin, body: {value, out, _ in
                out = true
            })
            .onChanged({value in
                let translation = value.translation.width
                offset = (isDraggin ? translation: .zero)
                
            })
            .onEnded({ value in
                let width = getRect().width - 50
                let translation = value.translation.width
                
                let checkingStatus = (translation > 0 ?
                                      translation : translation)
                
                withAnimation{
                    if checkingStatus > (width / 2){
                        offset = (translation > 0 ? width: -width) * 2
                        endSwipeAction()
                }
                else{
                    offset = .zero
                }
            }
        })
    )
}
    func getRotation(angle: Double)->Double{
        
        let rotation = (offset / (getRect().width - 50)) * angle
        
        return rotation
        
    }
    
    func endSwipeAction(){
        withAnimation(.none){endSwipe = true}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            if let _ = imageVisualizationControlller.annotation?.images.first{
                let _ = withAnimation{
                    imageVisualizationControlller.annotation?.images.removeFirst()
                }
            }
        }
    }
}

extension View{
    func getRect()->CGRect{
    return UIScreen.main.bounds
    }
}
