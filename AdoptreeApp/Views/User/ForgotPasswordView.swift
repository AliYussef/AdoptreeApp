//
//  ForgotPasswordView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State var email:String = ""
    
    var body: some View {
        ZStack{
            Color.init("color_background")
                .edgesIgnoringSafeArea(.bottom)
            VStack {
                TextField("Email Address", text: $email)
                    .padding()
                    .background(Color.init("color_textfield"))
                    .cornerRadius(8.0)
                    .keyboardType(.default)
                    .autocapitalization(.none)
                    .padding()
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Reset my password")
                        .bold()
                        .foregroundColor(.white)
                })
                .frame(width: 230, height: 50, alignment: .center)
                .background(Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
            }
        }
        .navigationBarTitle("Forgot password", displayMode: .inline)
        
        
        
        
        
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
