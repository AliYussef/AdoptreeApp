//
//  TourBookingView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct TourBookingView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var availableSlotsIndex = 0
    
    var availableSlots = 100
    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
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
                
                
                NavigationLink(destination: BookedTourOverviewView())
                {
                    Text("Confirm")
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(width: 180, height: 50, alignment: .center)
                .background(Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
            }
        }
    }
}

struct TourBookingView_Previews: PreviewProvider {
    static var previews: some View {
        TourBookingView()
    }
}
