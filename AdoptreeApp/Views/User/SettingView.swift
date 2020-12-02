//
//  SettingView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct SettingView: View {
    @State private var languagesIndex = 0
    var languages = ["English", "Dutch"]
    @State var isGrowthOn = true
    @State var isHumidityOn = true
    @State var isTemperatureOn = true
    @State var isCO2ReductionOn = true
    @State var isCO2RedutionTipsOn = true
    @State var isEventsOn = false
    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                // notifications
                Form {
                    Section(header: HStack {
                        Text("notifications")
                            .foregroundColor(.init("color_font_secondary"))
                    }, content: {
                        
                        Toggle(isOn: $isGrowthOn) {
                            Text("Growth")
                        }
                        Toggle(isOn: $isHumidityOn) {
                            Text("Humidity")
                        }
                        Toggle(isOn: $isTemperatureOn) {
                            Text("Temperature")
                        }
                        Toggle(isOn: $isCO2ReductionOn) {
                            Text("CO2 reduction")
                        }
                        Toggle(isOn: $isCO2RedutionTipsOn) {
                            Text("CO2 redution tips")
                        }
                        Toggle(isOn: $isEventsOn) {
                            Text("Events")
                        }
                    })
                    
                    //general
                    Section(header: HStack {
                        Text("general")
                            .foregroundColor(.init("color_font_secondary"))
                    }, content: {
                        Picker(selection: $languagesIndex, label: Text("Choose language").font(.subheadline)) {
                            ForEach(0 ..< languages.count) {
                                Text(self.languages[$0])
                            }
                        }
                    })
                    
                    //information
                    Section(header: HStack {
                        Text("information")
                            .foregroundColor(.init("color_font_secondary"))
                    }, content: {
                        
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0")
                        }
                        NavigationLink(
                            destination: Text("Destination"),
                            label: {
                                Text("Privacy policy")
                            })
                        NavigationLink(
                            destination: Text("Destination"),
                            label: {
                                Text("Over this app")
                            })
                        NavigationLink(
                            destination: Text("Destination"),
                            label: {
                                Text("Share this app")
                            })
                        NavigationLink(
                            destination: Text("Destination"),
                            label: {
                                Text("Rate us")
                                    .foregroundColor(.init("color_primary_accent"))
                            })
                        NavigationLink(
                            destination: Text("Destination"),
                            label: {
                                Text("Contact")
                                    .foregroundColor(.init("color_primary_accent"))
                            })
                    })
                    
                    //logo
                    Section(header: HStack {
                        Spacer()
                        
                        Image("icon_adoptiebos")
                            .resizable()
                            .frame(width: 50, height:  50, alignment: .center)
                        
                        Text("ADOPTREE")
                            .foregroundColor(.init("color_logo"))
                        
                        Spacer()
                    }, content: {})
                    .padding()
                    
                }.background(Color.init("color_background"))
                .padding(.top, 10)
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
