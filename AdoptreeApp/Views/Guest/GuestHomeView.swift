//
//  GuestHomeView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct GuestHomeView: View {
    var body: some View {
//        ZStack {
//            Color.init("color_background")
//                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    
                    NavigationLink(destination: TreeSelectionView())
                    {
                        Text("Adopt now")
                            .bold()
                            .foregroundColor(.white)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 50, alignment: .center)
                    .background(Color.init("color_primary_accent"))
                    .cornerRadius(10.0)
                    .padding()
                    
                    RoundedRectangle(cornerRadius: 12.0)
                        .fill(Color.white)
                        .frame(width: .none, height: 100, alignment: .center)
                        .overlay(
                            Text("Why adopting a tree, why ADOPTREE?")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.init("color_font_primary"))
                                .multilineTextAlignment(.center)
                                .padding())
                        .padding(.bottom)
                    
                    RoundedRectangle(cornerRadius: 12.0)
                        .fill(Color.white)
                        .frame(width: .none, height: 200, alignment: .center)
                        .overlay(
                            HStack(alignment: .top){
                                Image("plant_tree")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 160, alignment: .center)
                                    .cornerRadius(12.0)
                                
                                VStack(alignment: .leading) {
                                    Text("Select your tree")
                                        .font(.subheadline)
                                        .foregroundColor(.init("color_font_primary"))
                                        .padding(.bottom, 2)
                                    
                                    Text("The foundation will take care of planting your selected tree in the desired location")
                                        .font(.caption)
                                        .foregroundColor(.init("color_font_secondary"))
                                    
                                    NavigationLink(destination: TreeSelectionView())
                                    {
                                        Text("Available trees")
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.35, height: 40, alignment: .center)
                                    .background(Color.init("color_primary_accent"))
                                    .cornerRadius(10.0)
                                    .padding()
                                }
                                .padding(.leading)
                            }.padding()
                        )
                        .padding(.bottom)
                    
                    RoundedRectangle(cornerRadius: 12.0)
                        .fill(Color.white)
                        .frame(width: .none, height: 200, alignment: .center)
                        .overlay(
                            HStack(alignment: .top){
                                VStack(alignment: .leading) {
                                    Text("Monitor your tree")
                                        .font(.subheadline)
                                        .foregroundColor(.init("color_font_primary"))
                                        .padding(.bottom, 2)
                                    
                                    Text("You will be able to keep track tree's growth, temperature, hunidity and most importantly your CO2 reduction. Your tree will be photographed and geolocated as well")
                                        .font(.caption)
                                        .foregroundColor(.init("color_font_secondary"))
                                }
                                .padding(.leading)
                                
                                Image("monitoring_tree")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 160, alignment: .center)
                                    .cornerRadius(12.0)
                            }.padding()
                        )
                        .padding(.bottom)
                    
                    RoundedRectangle(cornerRadius: 12.0)
                        .fill(Color.white)
                        .frame(width: .none, height: 200, alignment: .center)
                        .overlay(
                            HStack(alignment: .top){
                                Image("timeline")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 160, alignment: .center)
                                    .cornerRadius(12.0)
                                
                                VStack(alignment: .leading) {
                                    Text("Follow its story")
                                        .font(.subheadline)
                                        .foregroundColor(.init("color_font_primary"))
                                        .padding(.bottom, 2)
                                    
                                    Text("You will be able to see your tree achievments and important milestones through the timeline")
                                        .font(.caption)
                                        .foregroundColor(.init("color_font_secondary"))
                                    
                                }
                                .padding(.leading)
                            }.padding()
                        )
                        .padding(.bottom)
                    
                    RoundedRectangle(cornerRadius: 12.0)
                        .fill(Color.white)
                        .frame(width: .none, height: 200, alignment: .center)
                        .overlay(
                            HStack(alignment: .top){
                                VStack(alignment: .leading) {
                                    Text("Make the planet greener")
                                        .font(.subheadline)
                                        .foregroundColor(.init("color_font_primary"))
                                        .padding(.bottom, 2)
                                    
                                    Text("As your tree grows, it will absorb CO2. This will mitigate the effects of climate change, protect the soil and wildlife, and help maintain the biodiversity")
                                        .font(.caption)
                                        .foregroundColor(.init("color_font_secondary"))
                                }
                                .padding(.leading)
                                
                                Image("green_planet")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 160, alignment: .center)
                                    .cornerRadius(12.0)
                            }.padding()
                        )
                        .padding(.bottom)
                    
                    RoundedRectangle(cornerRadius: 12.0)
                        .fill(Color.white)
                        .frame(width: .none, height: 200, alignment: .center)
                        .overlay(
                            HStack(alignment: .top){
                                Image("contribute")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 160, alignment: .center)
                                    .cornerRadius(12.0)
                                
                                VStack(alignment: .leading) {
                                    Text("Adopt now")
                                        .font(.subheadline)
                                        .foregroundColor(.init("color_font_primary"))
                                        .padding(.bottom, 2)
                                    
                                    Text("Contribute now by adopting a tree")
                                        .font(.caption)
                                        .foregroundColor(.init("color_font_secondary"))
                                    
                                    NavigationLink(destination: TreeSelectionView())
                                    {
                                        Text("Adopt now")
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.35, height: 40, alignment: .center)
                                    .background(Color.init("color_primary_accent"))
                                    .cornerRadius(10.0)
                                    .padding()
                                }
                                .padding(.leading)
                            }.padding()
                        )
                        .padding(.bottom)
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .center)
            }
            
            
//        }
//        .navigationBarTitle("HOME", displayMode: .inline)
//        .navigationBarBackButtonHidden(true)
    }
}

struct GuestHomeView_Previews: PreviewProvider {
    static var previews: some View {
        GuestHomeView()
    }
}
