//
//  AvailableToursView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct AvailableToursView: View {
    @ObservedObject var newsViewModel: NewsViewModel
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading) {
                    
                    Text("Book a tour")
                        .font(.title3)
                        .foregroundColor(.init("color_font_primary"))
                        .padding()
                    
                    if !newsViewModel.tours.isEmpty {
                        
                        ForEach(newsViewModel.tours) { tour in
                            NavigationLink(
                                destination: TourBookingView(newsViewModel: newsViewModel, tour: tour),
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
    let tour: Tour
    
    var body: some View {
        VStack {
            HStack {
                Image("tour_icon")
                    .resizable()
                    .frame(width: 75, height: 75, alignment: .center)
                
                VStack(alignment: .leading) {
                    Text("10 December 2020")
                        .font(.body)
                        .foregroundColor(.init("color_font_primary"))
                        .padding(.bottom, 5)
                    
                    HStack {
                        Text("14:00 - 15:00.")
                            .font(.caption)
                            .foregroundColor(.init("color_font_secondary"))
                        
                        Text("Haarlem")
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
