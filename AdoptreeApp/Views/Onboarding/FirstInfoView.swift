//
//  FirstInfoView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct FirstInfoView: View {
    @Binding var currentIndex: Int
    
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
            
            HStack {
                Spacer()
                
                Button(action: {
                    withAnimation(.linear){
                        self.currentIndex += 1
                    }
                }, label: {
                    Text("Next")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 28, height: 28, alignment: .trailing)
                        .foregroundColor(.white)
                })
                .frame(width: UIScreen.main.bounds.width * 0.35, height: 40, alignment: .center)
                .background(Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
            }
            
            Spacer()
        }
    }
}
