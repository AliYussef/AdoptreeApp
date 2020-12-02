//
//  OverTheAppView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 02/12/2020.
//

import SwiftUI

struct OverTheAppView: View {
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading) {
                    Text("Over this app")
                        .font(.title)
                        .foregroundColor(.init("color_font_primary"))
                        .padding(.bottom)
                    
                    Text("This free app from Adoptiebos foundation provide the user with the ability to adopt trees to help reduce his/her CO2 footprint. It also allow the user to monitor his/her tree status over time and how well the tree is doing")
                        .font(.body)
                        .foregroundColor(.init("color_font_primary"))
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .leading)
                .padding()
            }
        }
    }
}

struct OverTheAppView_Previews: PreviewProvider {
    static var previews: some View {
        OverTheAppView()
    }
}
