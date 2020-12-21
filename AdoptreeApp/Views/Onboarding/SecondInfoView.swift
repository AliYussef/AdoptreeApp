//
//  SecondInfoView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct SecondInfoView: View {
    @Binding var currentIndex: Int
    
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
            
            HStack {
                Button(action: {
                    withAnimation(.linear){
                    self.currentIndex -= 1
                    }
                }, label: {
                    Image(systemName: "arrow.backward.circle.fill")
                        .resizable()
                        .frame(width: 28, height: 28, alignment: .trailing)
                        .foregroundColor(.white)
                    
                    Text("Previous")
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .frame(width: UIScreen.main.bounds.width * 0.35, height: 40, alignment: .center)
                .background(Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
                
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

struct SecondInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SecondInfoView(currentIndex: .constant(1))
    }
}
