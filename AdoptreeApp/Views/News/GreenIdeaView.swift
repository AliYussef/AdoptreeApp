//
//  GreenIdeaView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct GreenIdeaView: View {
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading) {
                    Text("GREEN IDEAS")
                        .font(.title2)
                        .foregroundColor(.init("color_font_primary"))
                        .padding()
                    
                    NavigationLink(
                        destination: GreenIdeaDetailView(),
                        label: { GreenIdeaCellView() })
                    NavigationLink(
                        destination: GreenIdeaDetailView(),
                        label: { GreenIdeaCellView() })
                    NavigationLink(
                        destination: GreenIdeaDetailView(),
                        label: { GreenIdeaCellView() })
                }
            }
        }
    }
}

struct GreenIdeaCellView: View {
    //let content: Content
    
    var body: some View {
        VStack {
            HStack {
                Image("green_idea")
                    .resizable()
                    .frame(width: 120, height: 120, alignment: .center)
                
                VStack(alignment: .leading) {
                    Text("10 December 2020")
                        .font(.body)
                        .foregroundColor(.init("color_font_primary"))
                        .padding(.bottom, 5)
                    
                    Text("25 October 2020")
                        .font(.caption)
                        .foregroundColor(.init("color_font_secondary"))
                }
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .topLeading)
        .background(Color.white)
        .cornerRadius(12.0)
        .padding(.bottom, 5)
    }
}

struct GreenIdeaView_Previews: PreviewProvider {
    static var previews: some View {
        GreenIdeaView()
    }
}
