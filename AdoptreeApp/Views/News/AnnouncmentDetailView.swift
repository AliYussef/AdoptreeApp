//
//  AnnouncmentDetailView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct AnnouncmentDetailView: View {
    let announcment: Content
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    
                    VStack {
                        Image(systemName: "newspaper")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 150, alignment: .center)
                            .foregroundColor(.init("color_primary_accent"))
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 180, alignment: .center)
                    .padding()
                    .background(Color.white)
                    
                    VStack {
                        Text("\(announcment.title)")
                            .font(.title2)
                            .foregroundColor(.init("color_font_primary"))
                            .padding(10)
                        
                        Text("""
 \(announcment.text)
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
