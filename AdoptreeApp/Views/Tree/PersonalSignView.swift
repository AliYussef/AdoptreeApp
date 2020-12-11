//
//  PersonalSignView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI
import PencilKit

struct PersonalSignView: View {
    @ObservedObject var treeViewModel: TreeViewModel
    @EnvironmentObject var orderViewModel: OrderViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var treeSign = ""
    @State private var showingAlert = false
    @State private var message = ""
    let tree: Tree
    
    //@State var canvas = PKCanvasView()
    
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
                    
                    let order = self.orderViewModel.createTreeSignOrder(for: 1)
                    self.orderViewModel.createOrder(order: order) { result in
                        switch (result) {
                            case .failure(let error):
                                print(error)
                            case .success(let success):
                                if let url = URL(string: success.paymentLink) {
                                    if UIApplication.shared.canOpenURL(url) {
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    }
                                }
                        }
                    }
                    
                    if let treeSignProduct = orderViewModel.treeSign {
                        if let orderId = orderViewModel.orderResponse?.id {
                            let treeSign = treeViewModel.createTreeSignObject(tree: tree, treeSignProduct: treeSignProduct, signText: self.treeSign, orderId: orderId)
                            
                            if let treeSign = treeSign {
                                treeViewModel.createTreeSign(treeSign: treeSign) {  result in
                                    switch (result) {
                                        case .failure(_):
                                            self.message = "An error occurred. Please try again!"
                                            self.showingAlert.toggle()
                                        case .success(_):
                                            self.message = "Successfully purchased a sign"
                                            self.showingAlert.toggle()
                                            presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }
                        }
                    }
                }, label: {
                    Text("Confirm & pay")
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .frame(width: 180, height: 40, alignment: .center)
                .background(Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Personal sign"), message: Text("\(message)"), dismissButton: .default(Text("Ok")))
                }
                .disabled(treeViewModel.treeSign != nil)
                
            }
            .padding()
        }
        .onAppear {
            
            if treeViewModel.treeSign == nil {
                if let treeId = tree.assignedTree?.tree_id {
                    treeViewModel.getTreeSignByTree(for: treeId) {_ in}
                }
                
                if let signText = treeViewModel.treeSign?.sign_text {
                    treeSign = signText
                }
            }
            
            if orderViewModel.availableProducts.isEmpty {
                orderViewModel.getProductsAndCategories()
            }
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

//struct PersonalSignView_Previews: PreviewProvider {
//    static var previews: some View {
//        PersonalSignView()
//    }
//}
