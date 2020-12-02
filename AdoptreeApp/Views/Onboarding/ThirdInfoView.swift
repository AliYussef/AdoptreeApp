//
//  ThirdInfoView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct ThirdInfoView: View {
    @Binding  var showStartingView: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image("icon_adoptiebos")
                    .resizable()
                    .frame(width: 116, height: 118, alignment: .center)
                
                VStack(alignment: .leading) {
                    Text("Stichting")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.init("color_logo"))
                    Text("Adoptiebos")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
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
                //                CellView(iconName: "person.3.fill", iconImage: nil, title: "Adopters", info: "1K")
                //                    .padding(.trailing)
                CellView(iconName: "person.3.fill", iconImage: nil, iconWidth: nil, iconHeight: nil, title: "Adopters", info: "1K")
                    .padding(.trailing)
                // CellView(iconName: nil, iconImage: Image("pine"), title: "Forests", info: "2")
                CellView(iconName: nil, iconImage: Image("pine"), iconWidth: 30.0, iconHeight: 28.0, title: "Forests", info: "2")
                
                //                VStack {
                //                    Image(systemName: "person.3.fill")
                //                        .foregroundColor(.init("color_primary_accesnt"))
                //                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                //
                //                    Text("1K")
                //                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                //                        .bold()
                //                        .foregroundColor(.init("color_font_primary"))
                //
                //                    Text("Adopters")
                //                        .foregroundColor(.init("color_font_secondary"))
                //                }
                //                .frame(width: 165, height: 153, alignment: .center)
                //                .background(Color.init(.white))
                //                .cornerRadius(12.0)
                //                .padding(.trailing)
                //
                //                VStack {
                //                    Image("pine")
                //                        .resizable()
                //                        .frame(width: 30, height: 28, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                //                        .foregroundColor(.init("color_primary_accesnt"))
                //                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                //
                //                    Text("2")
                //                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                //                        .bold()
                //                        .foregroundColor(.init("color_font_primary"))
                //
                //                    Text("Forests")
                //                        .foregroundColor(.init("color_font_secondary"))
                //                }
                //                .frame(width: 165, height: 153, alignment: .center)
                //                .background(Color.init(.white))
                //                .cornerRadius(12.0)
            }
            .padding()
            
            
            HStack {
                //                CellView(iconName: nil, iconImage: Image("icon_tree"), title: "Adopters", info: "1K")
                //                    .padding(.trailing)
                CellView(iconName: nil, iconImage: Image("icon_tree"), iconWidth: 23.0, iconHeight: 28.0, title: "Trees", info: "2K")
                    .padding(.trailing)
                //CellView(iconName: nil, iconImage: Image("pine"), title: "Forests", info: "2")
                CellView(iconName: nil, iconImage: Image("icon_tree"), iconWidth: 23.0, iconHeight: 28.0, title: "Tree types", info: "2")
                //                VStack {
                //                    Image("icon_tree")
                //                        .resizable()
                //                        .frame(width: 23, height: 28, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                //                        .foregroundColor(.init("color_primary_accesnt"))
                //                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                //
                //                    Text("2K")
                //                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                //                        .bold()
                //                        .foregroundColor(.init("color_font_primary"))
                //
                //                    Text("Trees")
                //                        .foregroundColor(.init("color_font_secondary"))
                //                }
                //                .frame(width: 165, height: 153, alignment: .center)
                //                .background(Color.init(.white))
                //                .cornerRadius(12.0)
                //                .padding(.trailing)
                //
                //                VStack {
                //                    Image("icon_tree")
                //                        .resizable()
                //                        .frame(width: 23, height: 28, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                //                        .foregroundColor(.init("color_primary_accesnt"))
                //                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                //
                //                    Text("2")
                //                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                //                        .bold()
                //                        .foregroundColor(.init("color_font_primary"))
                //
                //                    Text("Tree types")
                //                        .foregroundColor(.init("color_font_secondary"))
                //                }
                //                .frame(width: 165, height: 153, alignment: .center)
                //                .background(Color.init(.white))
                //                .cornerRadius(12.0)
            }
            
            Spacer()
            
            //            NavigationLink(destination: StartingView())
            //            {
            //                Text("Start now")
            //                    .bold()
            //                    .foregroundColor(.white)
            //                Image(systemName: "arrow.right.circle.fill")
            //                    .resizable()
            //                    .frame(width: 28, height: 28, alignment: .trailing)
            //                    .foregroundColor(.white)
            //
            //            }
            //            .frame(width: 180, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            //            .background(Color.init("primary_button"))
            //            .cornerRadius(10.0)
            //            .padding()
            
            
            
            Button(action: {
                withAnimation {
                    self.showStartingView.toggle()
                }
                
            }, label: {
                Text("Start now")
                    .bold()
                    .foregroundColor(.white)
                
                Image(systemName: "arrow.right.circle.fill")
                    .resizable()
                    .frame(width: 28, height: 28, alignment: .trailing)
                    .foregroundColor(.white)
                
                
            })
            .frame(width: 180, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .background(Color.init("color_primary_accent"))
            .cornerRadius(10.0)
            .padding()
            Spacer()
        }
    }
}

struct CellView: View {
    let iconName: String?
    let iconImage: Image?
    let iconWidth: CGFloat?
    let iconHeight: CGFloat?
    let title: String
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
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
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
