//
//  NewsView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct NewsView: View {
    @ObservedObject var newsViewModel: NewsViewModel
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading) {
                    
                    VStack(alignment: .leading) {
                        Text("EVENTS")
                            .font(.title2)
                            .foregroundColor(.init("color_font_primary"))
                            .padding()
                        
                        VStack {
                            VStack (alignment: .leading) {
                                HStack {
                                    Text("Guided Tour")
                                        .foregroundColor(.init("color_font_primary"))
                                        .font(.title3)
                                    
                                    Spacer()
                                    
                                    NavigationLink(
                                        destination: AvailableToursView(newsViewModel: newsViewModel),
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
                                        
                                        Text("Book your guided tour through the forest where you have adopted your tree.")
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
                        
                        Text("Booked tours")
                            .font(.title3)
                            .foregroundColor(.init("color_font_primary"))
                            .padding()
                        
                        VStack {
                            
                            ForEach(newsViewModel.bookedTours) { bookedTour in
                                NavigationLink(
                                    destination: BookedTourOverviewView(bookedTour: bookedTour),
                                    label: {
                                        VStack(alignment: .leading) {
                                            Text("10 December 2020")
                                                .font(.body)
                                                .foregroundColor(.init("color_font_primary"))
                                                .padding(.bottom, 5)
                                            
                                            Text("14:00 - 15:00. English")
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
                    
                    
                    VStack(alignment: .leading) {
                        
                        Text("GREEN IDEAS")
                            .font(.title2)
                            .foregroundColor(.init("color_font_primary"))
                            .padding()
                        
                        VStack {
                            NavigationLink(
                                destination: GreenIdeaDetailView(),
                                label: {
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
                                })
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
                                    Label("Explore more", systemImage: "arrow.right")
                                        .foregroundColor(.init("color_font_primary"))
                                        .font(.subheadline)
                                })
                        }
                        
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .topLeading)
                    
                    
                    VStack(alignment: .leading) {
                        
                        Text("ANNOUNCMENTS")
                            .font(.title2)
                            .foregroundColor(.init("color_font_primary"))
                            .padding()
                        
                        VStack {
                            NavigationLink(
                                destination: AnnouncmentDetailView(),
                                label: {
                                    HStack {
                                        Image(systemName: "newspaper")
                                            .resizable()
                                            .foregroundColor(.init("color_primary_accent"))
                                            .frame(width: 100, height: 100, alignment: .center)
                                            .padding(.trailing)
                                        
                                        
                                        VStack(alignment: .leading) {
                                            Text("Stichting adoptiebos has recently reached 1k adopters.")
                                                .font(.body)
                                                .foregroundColor(.init("color_font_primary"))
                                                .padding(.bottom, 5)
                                            
                                            Text("25 October 2020")
                                                .font(.caption)
                                                .foregroundColor(.init("color_font_secondary"))
                                        }
                                    }
                                })
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
                                    Label("Explore more", systemImage: "arrow.right")
                                        .foregroundColor(.init("color_font_primary"))
                                        .font(.subheadline)
                                })
                        }
                        
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
}

//struct NewsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewsView()
//    }
//}
