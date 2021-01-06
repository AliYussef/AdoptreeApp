//
//  OverTheAppView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 02/12/2020.
//

import SwiftUI

struct OverTheAppView: View {
    @EnvironmentObject var newsViewModel: NewsViewModel
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading) {
                    if let content = newsViewModel.aboutContents.filter({$0.title.lowercased() == "over the app"}).first {
                        Text("\(content.title)")
                            .font(.title)
                            .foregroundColor(.init("color_font_primary"))
                            .padding(.bottom)
                        
                        Text("\(content.text)")
                            .font(.body)
                            .foregroundColor(.init("color_font_primary"))
                        
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .leading)
                .padding()
            }
        }
    }
}
