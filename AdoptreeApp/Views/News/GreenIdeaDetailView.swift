//
//  GreenIdeaDetailView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct GreenIdeaDetailView: View {
    let greenIdea: Content
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Image("gree_idea_header")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: .none, height: 200, alignment: .center)
                    
                    VStack {
                        Text("\(greenIdea.title)")
                            .font(.title2)
                            .foregroundColor(.init("color_font_primary"))
                            .padding(10)
                        
                        Text("""
\(greenIdea.text)
""")
                            .font(.body)
                            .foregroundColor(.init("color_font_secondary"))
                        
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .center)
                }
            }
        }
    }
}

