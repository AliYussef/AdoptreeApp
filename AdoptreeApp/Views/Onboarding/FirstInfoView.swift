//
//  FirstInfoView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct FirstInfoView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Let us green the planet")
                .font(.title)
                .bold()
                .foregroundColor(.init("color_font_primary"))
                .padding()
            
            Text("Reduce you CO2 footprint by adopting a tree")
                .font(.title2)
                .foregroundColor(.init("color_font_primary"))
                .multilineTextAlignment(.center)
                .padding()
            
            // this extra empty text to preserve the alignment
            // between the both floating ground
            Text("")
                .padding()
            
            Spacer()
            Image("floating_ground_plant")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            
            Spacer()
        }
    }
}

struct FirstInfoView_Previews: PreviewProvider {
    static var previews: some View {
        FirstInfoView()
    }
}
