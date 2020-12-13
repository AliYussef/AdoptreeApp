//
//  BookedTourOverviewView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct BookedTourOverviewView: View {
    let bookedTour: BookedTour
    let tour: Tour
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Tour overview")
                    .font(.title)
                    .foregroundColor(.init("color_font_primary"))
                    .padding()
                
                HStack {
                    Image("tour_guide")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .padding(.trailing)
                    
                    VStack(alignment: .leading) {
                        Text("Your guide")
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_secondary"))
                            .padding(.bottom, 3)
                        
                        Text("Name: \(tour.guideName)")
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_primary"))
                            .padding(.bottom, 0.5)
                        
                        Text("Specialities: \(tour.guideSpecialty)")
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_primary"))
                    }
                    
                    Spacer()
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .center)
                .background(Color.white)
                .cornerRadius(12.0)
                .padding(.bottom)
                
                HStack {
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .foregroundColor(.init("color_green"))
                        .padding(.trailing)
                    
                    VStack(alignment: .leading) {
                        Text("Tour info")
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_secondary"))
                            .padding(.bottom, 3)
                        
                        Text("Name: \(bookedTour.userName)")
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_primary"))
                            .padding(.bottom, 0.5)
                        
                        Text("Email: \(bookedTour.userEmail)")
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_primary"))
                            .padding(.bottom, 0.5)
                        
                        Text("Date: \(getTourDateTime(date: tour.dateTime))")
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_primary"))
                            .padding(.bottom, 0.5)
                        
                        Text("Location: Haarlem")
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_primary"))
                    }
                    
                    Spacer()
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .center)
                .background(Color.white)
                .cornerRadius(12.0)
                
                Spacer()
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .frame(width: UIScreen.main.bounds.width * 0.5, height: 40, alignment: .center)
                .background(Color.red)
                .cornerRadius(10.0)
                .padding()
            }
        }
    }
}

extension BookedTourOverviewView {
    
    func getTourDateTime(date: Date) -> String {
        let date = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd LLLL YYYY HH:mm"
        return dateFormatter.string(from: date)
    }
    
}
