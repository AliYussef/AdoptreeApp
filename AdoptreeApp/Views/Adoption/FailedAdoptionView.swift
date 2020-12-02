//
//  FailedAdoptionView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct FailedAdoptionView: View {
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Text("Your adoption has failed")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.init("color_font_primary"))
                
                //                Text("With your contribution CO2 emissions can be reduced, wildlife and biodiversity will further thrive.")
                //                    .multilineTextAlignment(.center)
                //                    .padding()
                //                    .font(.subheadline)
                //                    .foregroundColor(.init("color_font_primary"))
                
                Image("sad_tree")
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
                
                
                Spacer()
                
                NavigationLink(destination: AdoptionLoginView())
                {
                    Text("Go back")
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(width: 180, height: 50, alignment: .center)
                .background(Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
                
            }
        }
    }
}

struct FailedAdoptionView_Previews: PreviewProvider {
    static var previews: some View {
        FailedAdoptionView()
    }
}
