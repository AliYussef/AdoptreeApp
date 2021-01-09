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
    var languages = [Localization.settingGeneralEnglishLanguage, Localization.settingGeneralDutchLanguage]
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Form {
                    Section(header: HStack {
                        Text(Localization.settingNotification)
                            .foregroundColor(.init("color_font_secondary"))
                    }, content: {
                        Toggle(isOn: $notificationViewModel.notificationObject.growth.animation()) {
                            Text(Localization.treeGrowth)
                        }
                        Toggle(isOn: $notificationViewModel.notificationObject.humidity.animation()) {
                            Text(Localization.treeHumidity)
                        }
                        Toggle(isOn: $notificationViewModel.notificationObject.temperature.animation()) {
                            Text(Localization.treeTemperature)
                        }
                        Toggle(isOn: $notificationViewModel.notificationObject.co2Reduction.animation()) {
                            Text(Localization.treeCo2)
                        }
                        Toggle(isOn: $notificationViewModel.notificationObject.co2ReductionTip.animation()) {
                            Text(Localization.settingNotificationCo2Tips)
                        }
                        Toggle(isOn: $notificationViewModel.notificationObject.event.animation()) {
                            Text(Localization.settingNotificationEvents)
                        }
                        
                    })
                    
                    Section(header: HStack {
                        Text(Localization.settingGeneral)
                            .foregroundColor(.init("color_font_secondary"))
                    }, content: {
                        Picker(selection: $notificationViewModel.languagesIndex, label: Text(Localization.settingGeneralLanguage).font(.subheadline)) {
                            ForEach(0 ..< languages.count) {
                                Text(self.languages[$0])
                            }
                        }
                    })
                    
                    Section(header: HStack {
                        Text(Localization.settingInformation)
                            .foregroundColor(.init("color_font_secondary"))
                    }, content: {
                        
                        HStack {
                            Text(Localization.settingInformationVersion)
                            Spacer()
                            Text("1.0")
                        }
                        NavigationLink(
                            destination: PrivacyPolicyView(),
                            label: {
                                Text(Localization.settingInformationPrivacyPolicy)
                            })
                        NavigationLink(
                            destination: OverTheAppView(),
                            label: {
                                Text(Localization.settingInformationOverTheApp)
                            })
                        Button(action: {
                            actionSheet()
                        }, label: {
                            Text(Localization.settingInformationShareTheApp)
                                .foregroundColor(.black)
                        })
                        NavigationLink(
                            destination: Text("Destination"),
                            label: {
                                Text(Localization.settingInformationRateUs)
                                    .foregroundColor(.init("color_primary_accent"))
                            })
                        NavigationLink(
                            destination: Text("Destination"),
                            label: {
                                Text(Localization.settingInformationContact)
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

