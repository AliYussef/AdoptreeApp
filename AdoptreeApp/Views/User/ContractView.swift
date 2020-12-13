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
                    Text("White oak")
                        .foregroundColor(.init("color_font_secondary"))
                }
                
                HStack {
                    Text("Location")
                    Spacer()
                    Text("Netherlands")
                        .foregroundColor(.init("color_font_secondary"))
                }
                
                HStack {
                    Text("Start date")
                    Spacer()
                    Text("25-05-2020")
                        .foregroundColor(.init("color_font_secondary"))
                }
                
                HStack {
                    Text("End date")
                    Spacer()
                    Text("24-05-2021")
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
