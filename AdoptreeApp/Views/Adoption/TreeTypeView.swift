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
            .frame(width: .none, height: 180, alignment: .leading)
            .overlay(
                HStack {
                    Image("tree2")
                        .resizable()
                        .frame(width: 125, height: 150, alignment: .leading)
                    
                    VStack (alignment: .leading) {
                        Text("WHITE OAK")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.init("color_font_primary"))
                            .padding(.bottom, 2)
                        Text("CO2: -1500Kg")
                            .font(.body)
                            .foregroundColor(.init("color_font_secondary"))
                        Text("Age: 3 weeks")
                            .font(.body)
                            .foregroundColor(.init("color_font_secondary"))
                        Text("Price: € 35 EUR")
                            .font(.body)
                            .foregroundColor(.init("color_font_secondary"))
                        
                        HStack {
                            Button(action: {
                                
                            }, label: {
                                Text("Add")
                                    .foregroundColor(.white)
                            })
                            .frame(width: 100, height: 30, alignment: .center)
                            .background(Color.init("color_primary_accent"))
                            .cornerRadius(10.0)
                            
                            NavigationLink(destination: TreeInfoView())
                            {
                                Text("Tree info")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 100, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .background(Color.init("color_primary_accent"))
                            .cornerRadius(10.0)
                        }
                        .padding(.top, 10)
                        
                    }
                })
            .padding()
            .frame(width: UIScreen.main.bounds.width - 20, height: .none)
            .background(Color.white)
            .cornerRadius(12.0)
            .padding(.bottom, 10)
        //.padding(.bottom, 5)
    }
}

struct TreeTypeView_Previews: PreviewProvider {
    static var previews: some View {
        TreeTypeView()
    }
}
