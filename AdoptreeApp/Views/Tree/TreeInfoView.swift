//
//  TreeInfoView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct TreeInfoView: View {
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    
                    RoundedRectangle(cornerRadius: 12.0)
                        .fill(Color.white)
                        .frame(width: .none, height: 100, alignment: .center)
                        .overlay(
                            HStack(alignment: .top){
                                Image("tree_type")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70, alignment: .center)
                                
                                VStack(alignment: .leading) {
                                    Text("WHITE OAK")
                                        .font(.title2)
                                        .foregroundColor(.init("color_font_primary"))
                                        .padding(.bottom, 2)
                                    Text("Price: 35 EUR")
                                        .font(.body)
                                        .foregroundColor(.init("color_font_secondary"))
                                        .padding(.bottom, 2)
                                }
                                .padding(.leading)
                                Spacer()
                            }.padding()
                        )
                        .padding(.bottom)
                    
                    Text("""
Quercus alba typically reaches heights of 80 to 100 feet (24–30 m) at maturity, and its canopy can become quite massive as its lower branches are apt to extend far out laterally, parallel to the ground. Trees growing in a forest will become much taller than ones in an open area which develop to be short and massive. The Mingo Oak was the tallest known white oak at 145 feet before it was felled in 1938.[6] it It is not unusual for a white oak tree to be as wide as it is tall, but specimens growing at high altitudes may only become small shrubs.
                        
White oak may live 200 to 300 years, with some even older specimens known. The Wye Oak in Wye Mills, Maryland was estimated to be over 450 years old when it finally fell in a thunderstorm in 2002.
                        
Another noted white oak was the Great White Oak in Basking Ridge, New Jersey, estimated to have been over 600 years old when it died in 2016.
""")
                        .font(.body)
                        .foregroundColor(.init("color_font_secondary"))
                        .padding()
                    
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .leading)
                .background(Color.white)
                .cornerRadius(12.0)
                .padding()
            }
        }
    }
}

struct TreeInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TreeInfoView()
    }
}
