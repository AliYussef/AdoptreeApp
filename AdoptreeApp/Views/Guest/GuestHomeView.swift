//
//  GuestHomeView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct GuestHomeView: View {
    @EnvironmentObject var newsViewModel: NewsViewModel
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                
                NavigationLink(destination: TreeSelectionView())
                {
                    Text(Localization.adoptNowBtn)
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
                        Text(Localization.homeGuestTitle)
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
                                if let content = newsViewModel.aboutContents.filter({$0.title.lowercased() == "select your tree"}).first {
                                    Text("\(content.title)")
                                        .font(.subheadline)
                                        .foregroundColor(.init("color_font_primary"))
                                        .padding(.bottom, 2)
                                    
                                    Text("\(content.text)")
                                        .font(.caption)
                                        .foregroundColor(.init("color_font_secondary"))
                                }
                                
                                NavigationLink(destination: TreeTypesView())
                                {
                                    Text(Localization.homeGuestTress)
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
                                if let content = newsViewModel.aboutContents.filter({$0.title.lowercased() == "monitor your tree"}).first {
                                    Text("\(content.title)")
                                        .font(.subheadline)
                                        .foregroundColor(.init("color_font_primary"))
                                        .padding(.bottom, 2)
                                    
                                    Text("\(content.text)")
                                        .font(.caption)
                                        .foregroundColor(.init("color_font_secondary"))
                                }
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
                                if let content = newsViewModel.aboutContents.filter({$0.title.lowercased() == "follow its story"}).first {
                                    Text("\(content.title)")
                                        .font(.subheadline)
                                        .foregroundColor(.init("color_font_primary"))
                                        .padding(.bottom, 2)
                                    
                                    Text("\(content.text)")
                                        .font(.caption)
                                        .foregroundColor(.init("color_font_secondary"))
                                    
                                }
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
                                if let content = newsViewModel.aboutContents.filter({$0.title.lowercased() == "make the planet greener"}).first {
                                    Text("\(content.title)")
                                        .font(.subheadline)
                                        .foregroundColor(.init("color_font_primary"))
                                        .padding(.bottom, 2)
                                    
                                    Text("\(content.text)")
                                        .font(.caption)
                                        .foregroundColor(.init("color_font_secondary"))
                                    
                                }
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
                                Text(Localization.adoptNowBtn)
                                    .font(.subheadline)
                                    .foregroundColor(.init("color_font_primary"))
                                    .padding(.bottom, 2)
                                
                                Text(Localization.homeGuestAdoptionContribution)
                                    .font(.caption)
                                    .foregroundColor(.init("color_font_secondary"))
                                
                                NavigationLink(destination: TreeSelectionView())
                                {
                                    Text(Localization.adoptNowBtn)
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
    }
}
