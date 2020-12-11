//
//  BookedTourOverviewView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct BookedTourOverviewView: View {
    let bookedTour: BookedTour
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
                    
                    VStack(alignment: .leading) {
                        Text("Your guide")
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_secondary"))
                            .padding(.bottom, 3)
                        
                        Text("Name: Arjan Postman")
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_primary"))
                            .padding(.bottom, 0.5)
                        
                        Text("Specialities: Knows everything about the forest")
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_primary"))
                    }
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
                    
                    VStack(alignment: .leading) {
                        Text("Tour info")
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_secondary"))
                            .padding(.bottom, 3)
                        
                        Text("Name: Your Name")
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_primary"))
                            .padding(.bottom, 0.5)
                        
                        Text("Email: email@gmail.com")
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_primary"))
                            .padding(.bottom, 0.5)
                        
                        Text("Date: 10 October 2020 14:00 - 15:00")
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_primary"))
                            .padding(.bottom, 0.5)
                        
                        Text("Location: Haarlem")
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_primary"))
                    }
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .center)
                .background(Color.white)
                .cornerRadius(12.0)
                
                Spacer()
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Dismiss")
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

//struct BookedTourOverviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookedTourOverviewView()
//    }
//}
