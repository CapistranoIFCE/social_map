import SwiftUI

struct ImageVisualization: View {
    @StateObject var controller = ImageVisualizationController()
    
    var body: some View {
        VStack{
            Button{
            } label: {
                Image("AppIcon")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .overlay(
            
            Text(controller.annotation?.title ?? "")
                .font(.title.bold())
            )
            .foregroundColor(.black)
            .padding()
            
            ZStack{
                if let imagesAnnotation = controller.annotation?.images {
                    if imagesAnnotation.isEmpty{
                        Text("Todas as fotos foram visualizadas")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    else{
                        ForEach(imagesAnnotation.reversed(), id: \.self) { currentImage in
                            StackCardView(imageAnnotation: currentImage)
                                .environmentObject(controller)
                        }
                    }
                }
                else{
                    ProgressView()
                }
                
            }
            .padding(.top,30)
            .padding()
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // Action Buttons...
            HStack(spacing: 15){
                
                
                Button{
                    
                }label:{
                    
                    Image(systemName: "highlighter")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding(13)
                        .background(Color(.yellow))
                        .clipShape(Circle())
                    
                }
                Button{
                    
                }label:{
                    
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding(13)
                        .background(Color(.orange))
                        .clipShape(Circle())
                    
                }
                Button{
                   
                }label:{
                    
                    Image(systemName: "trash")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .padding(13)
                        .background(Color(.red))
                        .clipShape(Circle())
                    
                }
                
            }
            
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear {
 
        }
    }
}
