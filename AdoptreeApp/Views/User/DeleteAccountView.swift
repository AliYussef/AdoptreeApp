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
                VStack {
                    Form {
                        Picker(selection: $reasonsIndex, label: Text("Reason").font(.subheadline)) {
                            ForEach(0 ..< reasons.count) {
                                Text(self.reasons[$0])
                            }
                        }
                        
                        SecureField("Confirm password", text: $password)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                        
                    }.background(Color.init("color_background"))
                    .padding(.top, 50)
                    
                }
                Spacer(minLength: 10)
                Button(action: {
                    
                }, label: {
                    Text("Confirm")
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .frame(width: 180, height: 40, alignment: .center)
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
