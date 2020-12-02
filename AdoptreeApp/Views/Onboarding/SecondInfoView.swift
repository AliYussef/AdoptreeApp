//
//  SecondInfoView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct SecondInfoView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("While your tree grows not only your CO2 footprint will reduce, but Wildlife will thrive, air will be fresher and water will be cleaner")
                .font(.title2)
                .foregroundColor(.init("color_font_primary"))
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            Image("floating_ground_tree")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            
            Spacer()
        }
    }
}

struct SecondInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SecondInfoView()
    }
}
