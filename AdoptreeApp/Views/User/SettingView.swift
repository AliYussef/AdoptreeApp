//
//  SettingView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var notificationViewModel: NotificationViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var languagesIndex = 0
    var languages = ["English", "Dutch"]
    @State var isGrowthOn = true 
    @State var isHumidityOn = true
    @State var isTemperatureOn = true
    @State var isCO2ReductionOn = true
    @State var isCO2RedutionTipsOn = true
    @State var isEventsOn = false
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Form {
                    Section(header: HStack {
                        Text("notifications")
                            .foregroundColor(.init("color_font_secondary"))
                    }, content: {
                        Toggle(isOn: $notificationViewModel.notificationObject.growth.animation()) {
                            Text("Growth")
                        }
                        Toggle(isOn: $notificationViewModel.notificationObject.humidity.animation()) {
                            Text("Humidity")
                        }
                        Toggle(isOn: $notificationViewModel.notificationObject.temperature.animation()) {
                            Text("Temperature")
                        }
                        Toggle(isOn: $notificationViewModel.notificationObject.co2Reduction.animation()) {
                            Text("CO2 reduction")
                        }
                        Toggle(isOn: $notificationViewModel.notificationObject.co2ReductionTip.animation()) {
                            Text("CO2 redution tips")
                        }
                        Toggle(isOn: $notificationViewModel.notificationObject.event.animation()) {
                            Text("Events")
                        }
                        
                    })//.disabled(!userViewModel.isAuthenticated)
                    
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
                            destination: PrivacyPolicyView(),
                            label: {
                                Text("Privacy policy")
                            })
                        NavigationLink(
                            destination: OverTheAppView(),
                            label: {
                                Text("Over this app")
                            })
                        Button(action: {
                            actionSheet()
                        }, label: {
                            Text("Share this app")
                                .foregroundColor(.black)
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

extension SettingView {
    
    func actionSheet() {
        guard let data = URL(string: "https://www.apple.nl") else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

