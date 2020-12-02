//
//  ContractView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 02/12/2020.
//

import SwiftUI

struct ContractView: View {
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            List {
                HStack {
                    Text("Name")
                    Spacer()
                    Text("Your Name")
                        .foregroundColor(.init("color_font_secondary"))
                }
                
                HStack {
                    Text("Tree Type")
                    Spacer()
                    Text("Your Name")
                        .foregroundColor(.init("color_font_secondary"))
                }
                
                HStack {
                    Text("Name")
                    Spacer()
                    Text("Your Name")
                        .foregroundColor(.init("color_font_secondary"))
                }
                
                HStack {
                    Text("Name")
                    Spacer()
                    Text("Your Name")
                        .foregroundColor(.init("color_font_secondary"))
                }
                
                HStack {
                    Text("Name")
                    Spacer()
                    Text("Your Name")
                        .foregroundColor(.init("color_font_secondary"))
                }
            }
        }
    }
}

struct ContractView_Previews: PreviewProvider {
    static var previews: some View {
        ContractView()
    }
}
