//
//  BookedTourOverviewView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct BookedTourOverviewView: View {
    @EnvironmentObject var newsViewModel: NewsViewModel
    @EnvironmentObject var treeViewModel: TreeViewModel
    let bookedTour: BookedTour
    let tour: Tour
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showingAlert = false
    @State private var showingAlertConfirm = false
    @State private var message = LocalizedStringKey("")
    @State var isTryingToCancel: Bool = false
    
    var body: some View {
        ZStack {
            Color.init("color_background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(Localization.tourOverviewTitle)
                    .font(.title)
                    .foregroundColor(.init("color_font_primary"))
                    .padding()
                
                HStack {
                    Image("tour_guide")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .padding(.trailing)
                    
                    VStack(alignment: .leading) {
                        Text(Localization.tourOverviewGuide)
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_secondary"))
                            .padding(.bottom, 3)
                        
                        Text(Localization.tourOverviewGuideName(name: tour.guideName))
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_primary"))
                            .padding(.bottom, 0.5)
                        
                        Text(Localization.tourOverviewGuideSpecialities(specialities: tour.guideSpecialty))
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_primary"))
                    }
                    
                    Spacer()
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
                        .foregroundColor(.init("color_primary_accent"))
                        .padding(.trailing)
                    
                    VStack(alignment: .leading) {
                        Text(Localization.tourOverviewTourInfo)
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_secondary"))
                            .padding(.bottom, 3)
                        
                        Text(Localization.tourOverviewGuideUsername(username: bookedTour.userName))
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_primary"))
                            .padding(.bottom, 0.5)
                        
                        Text(Localization.tourOverviewGuideEmail(email: bookedTour.userEmail))
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_primary"))
                            .padding(.bottom, 0.5)
                        
                        Text(Localization.tourOverviewGuideDate(date: getTourDateTime(date: tour.dateTime)))
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_primary"))
                            .padding(.bottom, 0.5)
                        
                        Text(Localization.tourOverviewGuideLocation(location: treeViewModel.getForestName(of: tour.forestId)))
                            .font(.subheadline)
                            .foregroundColor(.init("color_font_primary"))
                    }
                    
                    Spacer()
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: .none, alignment: .center)
                .background(Color.white)
                .cornerRadius(12.0)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(Localization.tourOverviewTourAlertTitle), message: Text(message), dismissButton: .default(Text(Localization.okBtn)) {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                }
                
                Spacer()
                
                Button(action: {
                    message = Localization.tourCancelingConfirmation
                    showingAlertConfirm.toggle()
                }, label: {
                    Text(Localization.cancelBtn)
                        .font(.subheadline)
                        .foregroundColor(.white)
                })
                .frame(width: UIScreen.main.bounds.width * 0.5, height: 40, alignment: .center)
                .background(Color.red)
                .cornerRadius(10.0)
                .padding()
                .alert(isPresented: $showingAlertConfirm) {
                    Alert(title: Text(Localization.tourOverviewTourAlertTitle), message: Text(message), primaryButton: .default(Text(Localization.yesBtn)){
                        if let bookedTourId = bookedTour.id {
                            isTryingToCancel.toggle()
                            newsViewModel.cancelBookedTour(using: bookedTourId) { result in
                                switch (result) {
                                    case .failure(_):
                                        self.message = Localization.errorOccurred
                                        self.showingAlert.toggle()
                                    case .success(_):
                                        self.message = Localization.successfulCanceledTour
                                        self.showingAlert.toggle()
                                }
                                isTryingToCancel.toggle()
                            }
                        }
                    },secondaryButton: .cancel(Text(Localization.noBtn)))
                }
            }
            
            if isTryingToCancel {
                ProgressView(Localization.tourOverviewTourCancelingProgress)
            }
        }
    }
}

extension BookedTourOverviewView {
    
    func getTourDateTime(date: Date) -> String {
        let date = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd LLLL YYYY HH:mm"
        return dateFormatter.string(from: date)
    }
    
}
