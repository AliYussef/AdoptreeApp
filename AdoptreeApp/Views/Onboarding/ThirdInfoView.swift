//
//  ThirdInfoView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct ThirdInfoView: View {
    @Binding  var showStartingView: Bool
    @Binding var currentIndex: Int
    
    var body: some View {
        VStack {
            
            Spacer()
            
            HStack {
                Image("icon_adoptiebos")
                    .resizable()
                    .frame(width: 116, height: 118, alignment: .center)
                
                VStack(alignment: .leading) {
                    Text("Stichting")
                        .font(.title)
                        .foregroundColor(.init("color_logo"))
                    Text("Adoptiebos")
                        .font(.title)
                        .bold()
                        .foregroundColor(.init("color_logo"))
                }
            }
            .padding(.leading)
            .frame(width: 354, height: 134, alignment: .leading)
            .background(Color.init(.white))
            .cornerRadius(12.0)
            .padding()
            
            
            HStack {
                CellView(iconName: "person.3.fill", iconImage: nil, iconWidth: nil, iconHeight: nil, title: Localization.thirdInfoAdopters, info: "1K")
                    .padding(.trailing)
                CellView(iconName: nil, iconImage: Image("pine"), iconWidth: 30.0, iconHeight: 28.0, title: Localization.thirdInfoForests, info: "2")
            }
            .padding()
            
            
            HStack {
                CellView(iconName: nil, iconImage: Image("icon_tree"), iconWidth: 23.0, iconHeight: 28.0, title: Localization.thirdInfoTrees, info: "2K")
                    .padding(.trailing)
                CellView(iconName: nil, iconImage: Image("icon_tree"), iconWidth: 23.0, iconHeight: 28.0, title: Localization.thirdInfoTreeSpecies, info: "2")
            }
            .padding()
            
            
            Spacer()
            
            HStack {
                Button(action: {
                    withAnimation(.linear){
                        self.currentIndex -= 1
                    }
                }, label: {
                    Image(systemName: "arrow.backward.circle.fill")
                        .resizable()
                        .frame(width: 28, height: 28, alignment: .trailing)
                        .foregroundColor(.white)
                    
                    Text(Localization.prevBtn)
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .frame(width: UIScreen.main.bounds.width * 0.35, height: 40, alignment: .center)
                .background(Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        self.showStartingView.toggle()
                    }
                    
                }, label: {
                    Text(Localization.startNowBtn)
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 28, height: 28, alignment: .trailing)
                        .foregroundColor(.white)
                })
                .frame(width: UIScreen.main.bounds.width * 0.35, height: 40, alignment: .center)
                
                .background(Color.init("color_primary_accent"))
                .cornerRadius(10.0)
                .padding()
                
            }
            
            Spacer()
        }
    }
}

struct CellView: View {
    let iconName: String?
    let iconImage: Image?
    let iconWidth: CGFloat?
    let iconHeight: CGFloat?
    let title: LocalizedStringKey
    let info: String
    
    var body: some View {
        VStack {
            
            if let iconName = iconName {
                Image(systemName: iconName)
                    .foregroundColor(.init("color_primary_accent"))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            }
            
            if let iconImage = iconImage {
                iconImage
                    .resizable()
                    .frame(width: iconWidth, height: iconHeight, alignment: .center)
                    .foregroundColor(.init("color_primary_accent"))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            }
            
            Text(info)
                .font(.title)
                .bold()
                .foregroundColor(.init("color_font_primary"))
            
            Text(title)
                .foregroundColor(.init("color_font_secondary"))
        }
        .frame(width: 165, height: 153, alignment: .center)
        .background(Color.init(.white))
        .cornerRadius(12.0)
    }
}
