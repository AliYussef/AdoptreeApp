//
//  GreenIdeaView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct GreenIdeaView: View {
    @EnvironmentObject var newsViewModel: NewsViewModel
    
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
                    
                    ForEach(newsViewModel.informativeContents) { greenIdea in
                        NavigationLink(
                            destination: GreenIdeaDetailView(greenIdea: greenIdea),
                            label: { GreenIdeaCellView(greenIdea: greenIdea) })
                    }
                }
            }
        }
    }
}

struct GreenIdeaCellView: View {
    let greenIdea: Content
    
    var body: some View {
        VStack {
            HStack {
                Image("green_idea")
                    .resizable()
                    .frame(width: 120, height: 120, alignment: .center)
                
                VStack(alignment: .leading) {
                    Text("\(greenIdea.title)")
                        .font(.body)
                        .foregroundColor(.init("color_font_primary"))
                        .padding(.bottom, 5)
                    
                    Text(getHumanReadableDate(date: greenIdea.createdOn))
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

extension GreenIdeaCellView {
    
    func getHumanReadableDate(date: Date) -> String {
        let date = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        return dateFormatter.string(from: date)
    }
}
