//
//  SignupView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct SignupView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Form {
                    Section(header: HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.init("color_primary_accent"))
                        Text("Create an account")
                            .foregroundColor(.init("color_font_primary"))
                    }, content: {
                        TextField("First name", text: $firstName)
                        TextField("Last name", text: $lastName)
                        TextField("Email", text: $email)
                        TextField("Username", text: $username)
                        TextField("Password", text: $password)
                        TextField("Confirm password", text: $confirmPassword)
                    })
                }.background(Color.init("color_background"))
                .padding(.top, 50)
                
                //                NavigationLink(destination: HomeView())
                //                {
                //                    Text("Check out")
                //                        .bold()
                //                        .foregroundColor(.white)
                //                }
                //                .frame(width: 180, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                //                .background(Color.init("color_primary_accesnt"))
                //                .cornerRadius(10.0)
                //                .padding()
                
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
