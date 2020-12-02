//
//  DeleteAccountView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 02/12/2020.
//

import SwiftUI

struct DeleteAccountView: View {
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var reasonsIndex = 0
    
    var reasons = ["Not interested anymore", "Not convinced", "Too expensive", "Others"]
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            
            
            VStack {
                //                Picker(selection: $reasonsIndex, label: Text("Reason").font(.body
                //                ).padding()) {
                //                    ForEach(0 ..< reasons.count) {
                //                        Text(self.reasons[$0])
                //                    }
                //                }.pickerStyle(MenuPickerStyle())
                //                .foregroundColor(.gray)
                //                .frame(width: UIScreen.main.bounds.width * 0.9, height: 55, alignment: .leading)
                //                .background(Color.init("color_textfield"))
                //                .cornerRadius(8.0)
                
                VStack {
                    Form {
                        Picker(selection: $reasonsIndex, label: Text("Reason").font(.subheadline)) {
                            ForEach(0 ..< reasons.count) {
                                Text(self.reasons[$0])
                            }
                        }
                        
                        SecureField("Confirm password", text: $password)
                            //.padding()
                            //.background(Color.init("color_textfield"))
                            // .cornerRadius(8.0)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                        //.padding()
                    }.background(Color.init("color_background"))
                    .padding(.top, 50)
                    
                }
                Spacer(minLength: 10)
                Button(action: {
                    withAnimation {
                        //self.isAuthenticated.toggle()
                    }
                    
                }, label: {
                    Text("Confirm")
                        .bold()
                        .foregroundColor(.white)
                })
                .frame(width: 180, height: 50, alignment: .center)
                .background(Color.red)
                .cornerRadius(10.0)
                .padding()
            }
            
        }
    }
}

struct DeleteAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountView()
    }
}
