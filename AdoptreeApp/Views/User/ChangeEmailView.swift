//
//  ChangeEmailView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 02/12/2020.
//

import SwiftUI

struct ChangeEmailView: View {
    @State private var email = ""
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                TextField("New email address", text: $email)
                    .padding()
                    .background(Color.init("color_textfield"))
                    .cornerRadius(8.0)
                    .keyboardType(.default)
                    .autocapitalization(.none)
                    .padding()
                
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
                .background(Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
            }
            
        }
    }
}

struct ChangeEmailView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeEmailView()
    }
}
