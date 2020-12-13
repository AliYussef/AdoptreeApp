//
//  TreeInfoView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct TreeInfoView: View {
    let tree: Product
    
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
                                    Text("\(tree.name)")
                                        .font(.title2)
                                        .foregroundColor(.init("color_font_primary"))
                                        .padding(.bottom, 2)
                                    Text("Price: € \(String(format: "%.2f", tree.price)) EUR")
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
\(tree.description)
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

