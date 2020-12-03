//
//  TreeTypeView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct TreeTypeView: View {
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12.0)
            .fill(Color.white)
            .frame(width: UIScreen.main.bounds.width * 0.9, height: 160, alignment: .leading)
            .overlay(
                HStack {
                    Image("tree2")
                        .resizable()
                        .frame(width: 100, height: 125, alignment: .leading)
                    
                    VStack (alignment: .leading) {
                        Text("WHITE OAK")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.init("color_font_primary"))
                            .padding(.bottom, 2)
                        //                        Text("CO2: -1500Kg")
                        //                            .font(.body)
                        //                            .foregroundColor(.init("color_font_secondary"))
                        //                        Text("Age: 3 weeks")
                        //                            .font(.body)
                        //                            .foregroundColor(.init("color_font_secondary"))
                        
                        Text("Planted")
                            .font(.body)
                            .foregroundColor(.init("color_font_secondary"))
                        Text("Price: € 35 EUR")
                            .font(.body)
                            .foregroundColor(.init("color_font_secondary"))
                        
                        HStack {
                            Button(action: {
                                
                            }, label: {
                                Label("Add", systemImage: "cart.fill.badge.plus")
                                    .foregroundColor(.white)
                            })
                            .frame(width: 100, height: 30, alignment: .center)
                            .background(Color.init("color_primary_accent"))
                            .cornerRadius(10.0)
                            
                            NavigationLink(destination: TreeInfoView())
                            {
                                Label("Tree info", systemImage: "info")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 100, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .background(Color.init("color_primary_accent"))
                            .cornerRadius(10.0)
                        }
                        .padding(.top, 10)
                        
                    }
                    
                    Spacer()
                }.padding()
            )
            .padding(.bottom, 10)
        //.padding(.bottom, 5)
    }
}

struct TreeTypeView_Previews: PreviewProvider {
    static var previews: some View {
        TreeTypeView()
    }
}
