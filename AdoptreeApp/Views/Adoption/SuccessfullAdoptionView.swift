//
//  SuccessfullAdoptionView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct SuccessfullAdoptionView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Text("Thank you for your adoption")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.init("color_font_primary"))
                
                Text("With your contribution CO2 emissions can be reduced and wildlife and biodiversity will further thrive.")
                    .multilineTextAlignment(.center)
                    .padding()
                    
                    .font(.subheadline)
                    .foregroundColor(.init("color_font_primary"))
                
                Image("happy_tree")
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
                
                Spacer()
                
                Button(action: {
                    if self.userViewModel.isGuest {
                        self.userViewModel.isGuest.toggle()
                    }
                    self.userViewModel.isAuthenticated = true
                }, label: {
                    Text("Follow your tree")
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .frame(width: UIScreen.main.bounds.width * 0.5, height: 40, alignment: .center)
                .background(Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
                
            }
        }
        .navigationBarHidden(true)
    }
}

struct SuccessfullAdoptionView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessfullAdoptionView()
    }
}
