//
//  TourBookingView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct TourBookingView: View {
    @ObservedObject var newsViewModel: NewsViewModel
    let tour: Tour
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var availableSlotsIndex = 0
    var availableSlots = 100
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Book your free guided tour")
                    .font(.title)
                    .foregroundColor(.init("color_font_primary"))
                    .padding()
                
                HStack {
                    Image("tour_icon")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .padding(.leading)
                    
                    Text("During the tour a guide will walk you through the forest where you have adopted your tree.")
                        .font(.body)
                        .foregroundColor(.init("color_font_primary"))
                        .padding()
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .center)
                .background(Color.white)
                .cornerRadius(12.0)
                
                
                
                VStack {
                    Form {
                        Section(header: HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.init("color_primary_accent"))
                            Text("Fill in your information")
                                .foregroundColor(.init("color_font_primary"))
                        }, content: {
                            TextField("First name", text: $firstName)
                            TextField("Last name", text: $lastName)
                            TextField("Email", text: $email)
                            Picker(selection: $availableSlotsIndex, label: Text("Number of guests (including you)").font(.subheadline)) {
                                ForEach(0 ..< availableSlots) { num in
                                    Text("\(num)")
                                }
                            }
                        })
                    }.background(Color.init("color_background"))
                    .padding(.top, 50)
                }
                
                // should lead to BookedTourOverviewView()
                Button(action: {
                    //                    self.newsViewModel.bookTour(using: tour) { result in
                    //                        switch (result) {
                    //                            case .failure(_):
                    //                                print("")
                    //                            case .success(_):
                    //                                print("")
                    //                        }
                    //                    }
                }, label: {
                    Text("Confirm")
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .frame(width: UIScreen.main.bounds.width * 0.5, height: 40, alignment: .center)
                .background(Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
            }
        }
    }
}

