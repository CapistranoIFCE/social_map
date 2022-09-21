////
////  SheetsView.swift
////  SocialMap
////
////  Created by Raina Rodrigues de Lima on 20/09/22.
////
//
import Foundation
import SwiftUI

//struct SheetsView: View {
//
//    @State var showModal = false
//
//    var body: some View{
//
//        VStack{
//            Button {
//                showModal = true
//            } label: {
//                Text("Abrir modal")
//                    .padding()
//                    .background(Color.green)
//                    .foregroundColor(.white)
//            }
//
//    }  .sheet(item: $showModal){
//        ModalView()
//    }
//}
//
//struct ModalView: View {
//    var body: some View{
//        Text("Texto")
//    }
//}
//
//struct SheetsViewPreviviews:
//    PreviewProvider{
//    static var previews: some View{
//        SheetsView()
//    }
//}
//
//

struct SheetsView: View {
    @State private var isShowingSheet = false
    var body: some View {
        Button(action: {
            isShowingSheet.toggle()
        }) {
            Text("abrir sheet")
        }
        .sheet(isPresented: $isShowingSheet,
               onDismiss: didDismiss) {
            VStack {
                Text("""
                        Adicione texto aqui
                    """)
                .padding(50)
                Button("Voltar",
                       action: { isShowingSheet.toggle() })
            }
        }
    }
    
    func didDismiss() {
        // Handle the dismissing action.
    }
}
