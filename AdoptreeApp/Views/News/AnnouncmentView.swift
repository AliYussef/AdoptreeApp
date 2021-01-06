//
//  AnnouncmentView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct AnnouncmentView: View {
    @EnvironmentObject var newsViewModel: NewsViewModel
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading) {
                    Text("ANNOUNCMENTS")
                        .font(.title2)
                        .foregroundColor(.init("color_font_primary"))
                        .padding()
                    ForEach(newsViewModel.anncouncmentContents) { announcment in
                    NavigationLink(
                        destination: AnnouncmentDetailView(announcment: announcment),
                        label: { AnnouncmentCellView(announcment: announcment)})
               
                    }
                }
            }
        }
    }
}

struct AnnouncmentCellView: View {
    let announcment: Content
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "newspaper")
                    .resizable()
                    .frame(width: 120, height: 120, alignment: .center)
                    .foregroundColor(.init("color_primary_accent"))
                    .padding(.trailing)
                
                VStack(alignment: .leading) {
                    Text("\(announcment.title)")
                        .font(.body)
                        .foregroundColor(.init("color_font_primary"))
                        .padding(.bottom, 5)
                    
                    Text(getHumanReadableDate(date: announcment.createdOn))
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

extension AnnouncmentCellView {
    
    func getHumanReadableDate(date: Date) -> String {
        let date = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        return dateFormatter.string(from: date)
    }
}
