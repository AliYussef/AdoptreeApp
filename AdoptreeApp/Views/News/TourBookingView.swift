//
//  TourBookingView.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import SwiftUI

struct TourBookingView: View {
    @ObservedObject var inputValidationViewModel = InputValidationViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var newsViewModel: NewsViewModel
    let tour: Tour
    @State var bookedTour: BookedTour?
    @State private var availableSlotsIndex = 0
    @State private var showingAlert = false
    @State private var showingAlertInput = false
    @State private var message = LocalizedStringKey("")
    @State var isTryingToBook: Bool = false
    @State var wasBookingSuccessfull: Bool = false
    @State var isConfirmDisabled = true
    
    var body: some View {
        
        if !wasBookingSuccessfull {
            ZStack {
                Color.init("color_background")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text(Localization.bookGuidedTourText)
                        .font(.title)
                        .foregroundColor(.init("color_font_primary"))
                        .padding()
                    
                    HStack {
                        Image("tour_icon")
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                            .padding(.leading)
                        
                        Text(Localization.bookGuidedTourExpl)
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
                                Text(Localization.bookGuidedTourInfromation)
                                    .foregroundColor(.init("color_font_primary"))
                            }, content: {
                                TextField(Localization.usernameField, text: $inputValidationViewModel.username)
                                    .validation(inputValidationViewModel.usernameValidation)
                                TextField(Localization.emailField, text: $inputValidationViewModel.email)
                                    .validation(inputValidationViewModel.emailEmptyValidation)
                                    .validation(inputValidationViewModel.emailValidation)
                                Picker(selection: $availableSlotsIndex, label: Text(Localization.bookGuidedTourGuestsNumber).font(.subheadline)) {
                                    ForEach(1 ..< Int(tour.slots)) { num in
                                        Text("\(num)")
                                    }
                                }
                            })
                        }.background(Color.init("color_background"))
                        .padding(.top, 50)
                    }
                    .alert(isPresented: $showingAlertInput) {
                        Alert(title: Text(Localization.bookGuidedTourAlertTitle), message: Text(message), dismissButton: .default(Text(Localization.okBtn)))
                    }
                    .onReceive(inputValidationViewModel.requestResetPasswordValidation) { validation in
                        isConfirmDisabled = !validation.isSuccess
                    }
                    
                    Button(action: {
                        isTryingToBook.toggle()
                        if let userId = userViewModel.userShared.id {
                            let bookedTour = BookedTour(id: nil, tourId: tour.id, userId: userId, userName: inputValidationViewModel.username, userEmail: inputValidationViewModel.email, bookedDateTime: nil)
                            self.newsViewModel.bookTour(using: bookedTour) { result in
                                switch (result) {
                                    case .failure(_):
                                        self.message = Localization.errorOccurred
                                        self.showingAlert.toggle()
                                    case .success(let result):
                                        self.bookedTour = result
                                        self.message = Localization.successfulTourBooking
                                        self.showingAlert.toggle()
                                }
                                
                                isTryingToBook.toggle()
                            }
                        }
                    }, label: {
                        Text(Localization.confirmBtn)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    })
                    .disabled(isConfirmDisabled)
                    .frame(width: UIScreen.main.bounds.width * 0.5, height: 40, alignment: .center)
                    .background(Color.init("color_primary_accent"))
                    .cornerRadius(10.0)
                    .padding()
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(Localization.bookGuidedTourAlertTitle), message: Text(message), dismissButton: .default(Text(Localization.okBtn)) {
                            self.wasBookingSuccessfull.toggle()
                        })
                    }
                }
                
                if isTryingToBook {
                    ProgressView(Localization.bookGuidedTourProgress)
                }
            }
            .onAppear {
                if let username = userViewModel.userShared.username {
                    if let email = userViewModel.userShared.email {
                        inputValidationViewModel.username = username
                        inputValidationViewModel.email = email
                    }
                }
            }
            
        } else {
            if let bookedTour = bookedTour {
                BookedTourOverviewView(bookedTour: bookedTour, tour: tour)
            }
        }
    }
}

