//
//  LoginView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @Binding var isAuthenticated: Bool
    @Binding var isGuest: Bool
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.init("color_background")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Text("Sign In to monitor your adopted tree")
                        .font(.title2)
                        .foregroundColor(.init("color_font_primary"))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Spacer()
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.init("color_textfield"))
                        .cornerRadius(8.0)
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .padding()
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.init("color_textfield"))
                        .cornerRadius(8.0)
                        .keyboardType(.default)
                        .autocapitalization(.none)
                        .padding()
                    
                    Button(action: {
                        withAnimation {
                            self.isAuthenticated.toggle()
                        }
                        
                    }, label: {
                        Text("Log in")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    })
                    .frame(width: 180, height: 40, alignment: .center)
                    .background(Color.init("color_primary_accent"))
                    .cornerRadius(10.0)
                    .padding()
                    
                    //                    NavigationLink(destination: ContentView())
                    //                    {
                    //                        Text("Log in")
                    //                            .bold()
                    //                            .foregroundColor(.white)
                    //                    }
                    //                    .frame(width: 180, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    //                    .background(Color.init("primary_button"))
                    //                    .cornerRadius(10.0)
                    //                    .padding()
                    
                    HStack {
                        Text("Haven’t adopted a tree yet?")
                            .foregroundColor(.init("color_font_primary"))
                        //                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        //                        Text("Adopt Now!")
                        //                            .bold()
                        //                            .foregroundColor(Color.init("font_primary"))
                        //                    })
                        NavigationLink(destination: TreeSelectionView())
                        {
                            Text("Adopt Now!")
                                .bold()
                                .foregroundColor(.init("color_font_primary"))
                        }
                        
                    }
                    .padding()
                    
                    NavigationLink(destination: ForgotPasswordView())
                    {
                        Text("Forgot password?")
                            .bold()
                            .foregroundColor(.init("color_font_primary"))
                    }
                    .padding()
                    //                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    //                    Text("Forgot password?")
                    //                        .bold()
                    //                        .foregroundColor(Color.init("font_primary"))
                    //                })
                    //                .padding()
                 
                    Spacer()
//                    NavigationLink(destination: GuestHomeView())
//                    {
//                        Text("Not now, maybe later")
//                            .bold()
//                            .foregroundColor(.init("color_font_primary"))
//                    }
//                    .padding()
                    
                    Button(action: {
                        withAnimation {
                            self.isGuest.toggle()
                        }
                        
                    }, label: {
                        Text("Not now, maybe later")
                            .bold()
                            .foregroundColor(.init("color_font_primary"))
                    })
//                    .frame(width: 180, height: 40, alignment: .center)
//                    .background(Color.init("color_primary_accent"))
//                    .cornerRadius(10.0)
                    .padding()
                    
                }
                .navigationBarBackButtonHidden(true)
                
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        
        
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
