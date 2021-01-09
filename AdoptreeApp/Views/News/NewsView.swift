//
//  NewsView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct NewsView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var newsViewModel: NewsViewModel
    @EnvironmentObject var treeViewModel: TreeViewModel
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading) {
                    
                    if userViewModel.isAuthenticated {
                        VStack(alignment: .leading) {
                            Text(Localization.newsEvents)
                                .font(.title2)
                                .foregroundColor(.init("color_font_primary"))
                                .padding()
                            
                            VStack {
                                VStack (alignment: .leading) {
                                    HStack {
                                        Text(Localization.newsGuidedTours)
                                            .foregroundColor(.init("color_font_primary"))
                                            .font(.title3)
                                        
                                        Spacer()
                                        
                                        NavigationLink(
                                            destination: AvailableToursView(),
                                            label: {
                                                Image(systemName: "plus")
                                                    .foregroundColor(.init("color_primary_accent"))
                                            })
                                    }
                                    
                                    HStack(alignment: .top) {
                                        Image("tour")
                                            .resizable()
                                            .frame(width: 120, height: 120, alignment: .center)
                                            .cornerRadius(12.0)
                                        
                                        VStack(alignment: .leading){
                                            Text("\(getCurrentMonth())'s tours")
                                                .font(.subheadline)
                                                .foregroundColor(.init("color_font_secondary"))
                                                .padding(.bottom, 3)
                                            
                                            Text(Localization.newsBookTourBody)
                                                .font(.body)
                                                .foregroundColor(.init("color_font_primary"))
                                        }
                                    }
                                }
                            }
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .topLeading)
                            .background(Color.white)
                            .cornerRadius(12.0)
                            .padding(.bottom, 5)
                            
                            if !newsViewModel.bookedTours.isEmpty {
                                Text(Localization.newsBookedTours)
                                    .font(.title3)
                                    .foregroundColor(.init("color_font_primary"))
                                    .padding()
                                
                                VStack {
                                    
                                    ForEach(newsViewModel.bookedTours) { bookedTour in
                                        ForEach(newsViewModel.tours) { tour in
                                            if tour.id == bookedTour.tourId {
                                                NavigationLink(
                                                    destination: BookedTourOverviewView(bookedTour: bookedTour, tour: tour),
                                                    label: {
                                                        VStack(alignment: .leading) {
                                                            Text(getTourDate(date: tour.dateTime))
                                                                .font(.body)
                                                                .foregroundColor(.init("color_font_primary"))
                                                                .padding(.bottom, 5)
                                                            
                                                            Text("\(getTourTime(date: tour.dateTime)). \(tour.language). \(treeViewModel.getForestName(of: tour.forestId))")
                                                                .font(.subheadline)
                                                                .foregroundColor(.init("color_font_secondary"))
                                                        }
                                                        .padding()
                                                        .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .topLeading)
                                                        .background(Color.white)
                                                        .cornerRadius(12.0)
                                                        .padding(.bottom, 5)
                                                    })
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        
                        Text(Localization.newsGreenIdeas)
                            .font(.title2)
                            .foregroundColor(.init("color_font_primary"))
                            .padding()
                        
                        VStack {
                            if let greenIdea = newsViewModel.informativeContents.first {
                                NavigationLink(
                                    destination: GreenIdeaDetailView(greenIdea: greenIdea),
                                    label: {
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
                                    })
                            }
                        }
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .topLeading)
                        .background(Color.white)
                        .cornerRadius(12.0)
                        .padding(.bottom, 5)
                        
                        HStack {
                            
                            Spacer()
                            
                            NavigationLink(
                                destination: GreenIdeaView(),
                                label: {
                                    Label(Localization.newsExploreMoreBtn, systemImage: "arrow.right")
                                        .foregroundColor(.init("color_font_primary"))
                                        .font(.subheadline)
                                })
                        }
                        
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .topLeading)
                    
                    VStack(alignment: .leading) {
                        Text(Localization.newsAnnouncments)
                            .font(.title2)
                            .foregroundColor(.init("color_font_primary"))
                            .padding()
                        
                        VStack {
                            if let announcment = newsViewModel.anncouncmentContents.first {
                                NavigationLink(
                                    destination: AnnouncmentDetailView(announcment: announcment),
                                    label: {
                                        HStack {
                                            Image(systemName: "newspaper")
                                                .resizable()
                                                .foregroundColor(.init("color_primary_accent"))
                                                .frame(width: 100, height: 100, alignment: .center)
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
                                    })
                            }
                        }
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .topLeading)
                        .background(Color.white)
                        .cornerRadius(12.0)
                        .padding(.bottom, 5)
                        
                        HStack {
                            Spacer()
                            
                            NavigationLink(
                                destination: AnnouncmentView(),
                                label: {
                                    Label(Localization.newsExploreMoreBtn, systemImage: "arrow.right")
                                        .foregroundColor(.init("color_font_primary"))
                                        .font(.subheadline)
                                })
                        }
                        .padding(.bottom)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .topLeading)
                    
                }
            }
        }
    }
}

extension NewsView {
    
    func getCurrentMonth() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }
    
    func getHumanReadableDate(date: Date) -> String {
        let date = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        return dateFormatter.string(from: date)
    }
    
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
