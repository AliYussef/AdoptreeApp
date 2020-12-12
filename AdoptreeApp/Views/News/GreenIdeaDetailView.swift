//
//  GreenIdeaDetailView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct GreenIdeaDetailView: View {
    //let greenIdeaContent: Content
    
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
                        Text("How to further reduce CO2 footprint?")
                            .font(.title2)
                            .foregroundColor(.init("color_font_primary"))
                            .padding(10)
                        
                        Text("1. Eat less red meat. Traditional red meat comes from ruminant livestock such as cattle and sheep. These animals produce large amounts of methane, which is a greenhouse gas that packs 72 times the punch of CO2 over a 20 year period. Other types of meat, such as chicken, pork or kangaroo, produce far less emissions. At average levels of consumption, a family’s emissions from beef would easily outweigh the construction and running costs of a large 4WD vehicle, in less than 5 years. There is no need to cut out red meat entirely, but fewer steaks and snags mean far less CO2.")
                            .font(.body)
                            .foregroundColor(.init("color_font_secondary"))
                        
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .center)
                }
            }
        }
    }
}

struct GreenIdeaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GreenIdeaDetailView()
    }
}
