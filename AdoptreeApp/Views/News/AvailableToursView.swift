//
//  AvailableToursView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct AvailableToursView: View {
    @EnvironmentObject var newsViewModel: NewsViewModel
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading) {
                    
                    Text(Localization.bookTourText)
                        .font(.title3)
                        .foregroundColor(.init("color_font_primary"))
                        .padding()
                    
                    if !newsViewModel.tours.isEmpty {
                        
                        ForEach(newsViewModel.tours) { tour in
                            NavigationLink(
                                destination: TourBookingView(tour: tour),
                                label: {
                                    TourCellView(tour: tour)
                                })
                        }
                    }
                    
                }
            }
        }
    }
}

struct TourCellView: View {
    @EnvironmentObject var treeViewModel: TreeViewModel
    let tour: Tour
    
    var body: some View {
        VStack {
            HStack {
                Image("tour_icon")
                    .resizable()
                    .frame(width: 75, height: 75, alignment: .center)
                
                VStack(alignment: .leading) {
                    Text(getTourDate(date: tour.dateTime))
                        .font(.body)
                        .foregroundColor(.init("color_font_primary"))
                        .padding(.bottom, 5)
                    
                    HStack {
                        Text("\(getTourTime(date: tour.dateTime)).")
                            .font(.caption)
                            .foregroundColor(.init("color_font_secondary"))
                        
                        Text("\(tour.language).")
                            .font(.caption)
                            .foregroundColor(.init("color_font_secondary"))
                        
                        Text("\(treeViewModel.getForestName(of: tour.forestId))")
                            .font(.caption)
                            .foregroundColor(.init("color_font_secondary"))
                    }
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

extension TourCellView {
    
    func getTourDate(date: Date) -> String {
        let date = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd LLLL YYYY"
        return dateFormatter.string(from: date)
    }
    
    func getTourTime(date: Date) -> String {
        let date = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}
