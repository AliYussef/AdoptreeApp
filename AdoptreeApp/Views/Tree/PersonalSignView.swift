//
//  PersonalSignView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI
import PencilKit

struct PersonalSignView: View {
    // let tree: Tree
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var treeSign = ""
    
    @State var canvas = PKCanvasView()
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Add personal sign")
                    .font(.title)
                    .foregroundColor(.init("color_font_primary"))
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .leading)
  
                Spacer(minLength: 50)
                
                VStack {
                    Text("Personal sign")
                        .font(.title3)
                        .foregroundColor(.init("color_font_primary"))
                        .padding(.bottom, 2)
                    
                    Text("This sign will be placed next to your tree")
                        .font(.subheadline)
                        .foregroundColor(.init("color_font_primary"))
                }
                .padding()
                
                Form {
                    Section(header: Text("Tree sign"), content: {
                        TextField("Personal sign", text: $treeSign)
                        
                    })
                }
                
                
                //DrawingView(canvas: $canvas)
                
                Button(action: {
                    //call api and save changes
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Confirm & pay")
                        .bold()
                        .foregroundColor(.white)
                })
                .frame(width: 180, height: 50, alignment: .center)
                .background(Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
                
            }
            .padding()
        }
        .onAppear {

        }
    }
}

//struct DrawingView: UIViewRepresentable {
//
//    // to capture drawing for saving into album...
//    @Binding var canvas: PKCanvasView
//
//    func makeUIView(context: Context) -> PKCanvasView {
//        canvas.drawingPolicy = .anyInput
//        return canvas
//    }
//
//    func updateUIView(_ uiView: PKCanvasView, context: Context) {
//
//    }
//}

struct PersonalSignView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalSignView()
    }
}
