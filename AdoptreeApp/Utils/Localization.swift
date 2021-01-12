//
//  Localization.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import SwiftUI

/* Onbaording screens*/
enum Localization {
    static var firstInfoTitle: LocalizedStringKey {
        return "Let us green the planet"
    }
    
    static var firstInfoText: LocalizedStringKey {
        return "Reduce your CO2 footprint by adopting a tree"
    }
    
    static var secondInfoText: LocalizedStringKey {
        return "While your tree grows not only your CO2 footprint will reduce, but Wildlife will thrive, air will be fresher and water will be cleaner"
    }
    
    static var thirdInfoAdopters: LocalizedStringKey {
        return "Adopters"
    }
    
    static var thirdInfoForests: LocalizedStringKey {
        return "Forests"
    }
    
    static var thirdInfoTrees: LocalizedStringKey {
        return "Trees"
    }
    
    static var thirdInfoTreeSpecies: LocalizedStringKey {
        return "Tree species"
    }
    
    static var nextBtn: LocalizedStringKey {
        return "Next"
    }
    
    static var prevBtn: LocalizedStringKey {
        return "Previous"
    }
    
    static var startNowBtn: LocalizedStringKey {
        return "Start now"
    }
}

/* HomeView */
extension Localization {
    static var homeLoadingTrees: LocalizedStringKey {
        return "Loading your trees..."
    }
    
    static var homeTressNotPlantedYet: LocalizedStringKey {
        return "Your adopted trees have not been planted yet. Once they are planted you will be able to monitor their status."
    }
    
    static var homeAdoptMoreTreesBtn: LocalizedStringKey {
        return "Adopt more trees"
    }
    
    static var homeTotalCo2Reduced: LocalizedStringKey {
        return "Total CO2 Reduced"
    }
    
    static var homeEditTreeBtn: LocalizedStringKey {
        return "Edit tree"
    }
    
    static var homeAddSignBtn: LocalizedStringKey {
        return "Add sign"
    }
    
    static var homeShareTreeBtn: LocalizedStringKey {
        return "Share your tree"
    }
    
    static var homeAdoptedText: LocalizedStringKey {
        return "Adopted"
    }
    
    static var homeYearsText: LocalizedStringKey {
        return "years"
    }
    
    static var homeYearText: LocalizedStringKey {
        return "year"
    }
    
    static var homeAndText: LocalizedStringKey {
        return "and"
    }
    
    static var homeDaysText: LocalizedStringKey {
        return "days"
    }
    
    static var homeDayText: LocalizedStringKey {
        return "day"
    }
    
    static var homeAgoText: LocalizedStringKey {
        return "ago"
    }
    
    static var homeAdoptionPeriodText: LocalizedStringKey {
        return "Adoption period ends in"
    }
    
    static var homeTree: LocalizedStringKey {
        return "Tree"
    }
}

/* TreeView */
extension Localization {
    static var treeOverallHealth: LocalizedStringKey {
        return "Overall Health"
    }
    
    static var treeHealthy: LocalizedStringKey {
        return "Healthy"
    }
    
    static var treeUnhealthy: LocalizedStringKey {
        return "Unhealthy"
    }
    
    static var treeNotbad: LocalizedStringKey {
        return "Not bad"
    }
    
    static var treeCo2: LocalizedStringKey {
        return "CO2 Reduction"
    }
    
    static var treeGrowth: LocalizedStringKey {
        return "Growth"
    }
    
    static var treeTemperature: LocalizedStringKey {
        return "Temperature"
    }
    
    static var treeHumidity: LocalizedStringKey {
        return "Humidity"
    }
    
    static var treeGallery: LocalizedStringKey {
        return "Tree Gallery"
    }
    
    static var treeWildlife: LocalizedStringKey {
        return "Wildlife"
    }
    
    static var treeNoWildlife: LocalizedStringKey {
        return "No wildlife has been detected yet"
    }
    
    static var treeLocation: LocalizedStringKey {
        return "Tree Location"
    }
    
    static var treeLocationUnknown: LocalizedStringKey {
        return "Tree location is unknown"
    }
}

/* TimelineView */
extension Localization {
    static var timelineWeeklyResult: LocalizedStringKey {
        return "Weekly result"
    }
    
    static var timelineTreeImage: LocalizedStringKey {
        return "New tree image"
    }
    
    static var timelineAll: LocalizedStringKey {
        return "All"
    }
    
    static var timelineTree: LocalizedStringKey {
        return "Tree"
    }
    
    static var timelineDate: LocalizedStringKey {
        return "Date"
    }
    
    static var timelineLoading: LocalizedStringKey {
        return "Loading timeline..."
    }
    
    static var timelineTreeNotPlanted: LocalizedStringKey {
        return "Your adopted trees have not been planted yet. Once they are planted you will be able to follow their stories."
    }
}

/* TreePersonalizationView */
extension Localization {
    static var TreePersonalizationTitle: LocalizedStringKey {
        return "Personalize your tree"
    }
    
    static var TreePersonalizationTreeDetails: LocalizedStringKey {
        return "Tree details"
    }
    
    static var TreePersonalizationTreeName: LocalizedStringKey {
        return "Tree name"
    }
    
    static var TreePersonalizationTreeColor: LocalizedStringKey {
        return "Tree color"
    }
    
    static var TreePersonalizationAlertTitle: LocalizedStringKey {
        return "Personalisation"
    }
}

/* PersonalSignView */
extension Localization {
    static var personalSignTitle: LocalizedStringKey {
        return "Add personal sign"
    }
    
    static var personalSignText: LocalizedStringKey {
        return "Personal sign"
    }
    
    static var personalSignNote: LocalizedStringKey {
        return "This sign will be placed next to your tree"
    }
    
    static var personalSignTreeSign: LocalizedStringKey {
        return "Tree sign"
    }
    
    static var personalSignHasTreeSignNote: LocalizedStringKey {
        return "You already has a tree sign and you cannot order a new one at the moment"
    }
    
}

/* AdoptedTreesView */
extension Localization {
    static var adoptedTreesAlertTitle: LocalizedStringKey {
        return "Contract renewal"
    }
    
    static var adoptedTreesRenewBtn: LocalizedStringKey {
        return "Renew"
    }
    
    static var adoptedTreesTreeType: LocalizedStringKey {
        return "Tree Type"
    }
    
    static var adoptedTreesCountry: LocalizedStringKey {
        return "Country"
    }
    
    static var adoptedTreesForest: LocalizedStringKey {
        return "Forest"
    }
    
    static var adoptedTreesStartDate: LocalizedStringKey {
        return "Start date"
    }
    
    static var adoptedTreesEndDate: LocalizedStringKey {
        return "End date"
    }
    
    static var adoptedTreesUnknown: LocalizedStringKey {
        return "Unknown"
    }
}

/* NewsView */
extension Localization {
    static var newsEvents: LocalizedStringKey {
        return "EVENTS"
    }
    
    static var newsGuidedTours: LocalizedStringKey {
        return "Guided Tour"
    }
    
    static var newsBookTourBody: LocalizedStringKey {
        return "Book your guided tour through the forest where you have adopted your tree."
    }
    
    static var newsBookedTours: LocalizedStringKey {
        return "Booked tours"
    }
    
    static var newsGreenIdeas: LocalizedStringKey {
        return "GREEN IDEAS"
    }
    
    static var newsExploreMoreBtn: LocalizedStringKey {
        return "Explore more"
    }
    
    static var newsAnnouncments: LocalizedStringKey {
        return "ANNOUNCMENTS"
    }
}

/* Booking Screens */
extension Localization {
    static var bookTourText: LocalizedStringKey {
        return "Book a tour"
    }
    
    static var bookGuidedTourText: LocalizedStringKey {
        return "Book your free guided tour"
    }
    
    static var bookGuidedTourExpl: LocalizedStringKey {
        return "During the tour, a guide will walk you through the forest where you have adopted your tree."
    }
    
    static var bookGuidedTourInfromation: LocalizedStringKey {
        return "Fill in your information"
    }
    
    static var bookGuidedTourGuestsNumber: LocalizedStringKey {
        return "Number of guests (including you)"
    }
    
    static var bookGuidedTourAlertTitle: LocalizedStringKey {
        return "Tour booking"
    }
    
    static var bookGuidedTourProgress: LocalizedStringKey {
        return "Booking is in progress..."
    }
    
    static var tourOverviewTitle: LocalizedStringKey {
        return "Tour overview"
    }
    
    static var tourOverviewGuide: LocalizedStringKey {
        return "Your guide"
    }
    
    static func tourOverviewGuideName(name: String) -> LocalizedStringKey {
        return "Name: \(name)"
    }
    
    static func tourOverviewGuideSpecialities(specialities: String) -> LocalizedStringKey {
        return "Specialities: \(specialities)"
    }
    
    static var tourOverviewTourInfo: LocalizedStringKey {
        return "Tour info"
    }
    
    static func tourOverviewGuideLocation(location: String) -> LocalizedStringKey {
        return "Location: \(location)"
    }
    
    static func tourOverviewGuideUsername(username: String) -> LocalizedStringKey {
        return "Username: \(username)"
    }
    
    static func tourOverviewGuideEmail(email: String) -> LocalizedStringKey {
        return "Email: \(email)"
    }
    
    static func tourOverviewGuideDate(date: String) -> LocalizedStringKey {
        return "Date: \(date)"
    }
    
    static var tourOverviewTourAlertTitle: LocalizedStringKey {
        return "Tour cancelling"
    }
    
    static var tourOverviewTourCancelingProgress: LocalizedStringKey {
        return "cancelling is in progress..."
    }
}

/* User Views */
extension Localization {
    static var loginTitle: LocalizedStringKey {
        return "Sign In to monitor your adopted tree"
    }
    
    static var loginAlertTitle: LocalizedStringKey {
        return "Login"
    }
    
    static var loginNoAccountYet: LocalizedStringKey {
        return "Haven’t adopted a tree yet?"
    }
    
    static var loginAdoptNow: LocalizedStringKey {
        return "Adopt Now!"
    }
    
    static var loginForgotPassword: LocalizedStringKey {
        return "Forgot password?"
    }
    
    static var loginNotNow: LocalizedStringKey {
        return "Not now, maybe later"
    }
    
    static var loginProgress: LocalizedStringKey {
        return "Logging in..."
    }
    
    static var loginNoAccount: LocalizedStringKey {
        return "No account yet?"
    }
    
    static var loginAdoptingProgress: LocalizedStringKey {
        return "Adopting..."
    }
    
    static var signupTitle: LocalizedStringKey {
        return "Create an account"
    }
    
    static var signupAlertTitle: LocalizedStringKey {
        return "Signup"
    }
    
    static var resetPasswordAlertTitle: LocalizedStringKey {
        return "Password reset"
    }
    
    static var resetPasswordProgress: LocalizedStringKey {
        return "Changing password..."
    }
    
    static var forgotPasswordTitle: LocalizedStringKey {
        return "Forgot password"
    }
    
    static var forgotPasswordNote: LocalizedStringKey {
        return "Please check your email and fill in the reset token you received with a new password"
    }
    
    static var requestPasswordProgress: LocalizedStringKey {
        return "Requesting password change..."
    }
    
    static var profileYour: LocalizedStringKey {
        return "YOUR"
    }
    
    static var profileName: LocalizedStringKey {
        return "NAME"
    }
    
    static var profileContractTitle: LocalizedStringKey {
        return "Your contract"
    }
    
    static var profileChangeEmail: LocalizedStringKey {
        return "Change email address"
    }
    
    static var profileChangePassword: LocalizedStringKey {
        return "Chnage password"
    }
    
    static var profileDeleteAccount: LocalizedStringKey {
        return "Delete your account"
    }
    
    static var settingNotification: LocalizedStringKey {
        return "notifications"
    }
    
    static var settingNotificationCo2Tips: LocalizedStringKey {
        return "CO2 redution tips"
    }
    
    static var settingNotificationEvents: LocalizedStringKey {
        return "Events"
    }
    
    static var settingGeneral: LocalizedStringKey {
        return "general"
    }
    
    static var settingGeneralLanguage: LocalizedStringKey {
        return "Choose language"
    }
    
    static var settingGeneralEnglishLanguage: LocalizedStringKey {
        return "English"
    }
    
    static var settingGeneralDutchLanguage: LocalizedStringKey {
        return "Dutch"
    }
    
    static var settingInformation: LocalizedStringKey {
        return "information"
    }
    
    static var settingInformationVersion: LocalizedStringKey {
        return "Version"
    }
    
    static var settingInformationPrivacyPolicy: LocalizedStringKey {
        return "Privacy policy"
    }
    
    static var settingInformationOverTheApp: LocalizedStringKey {
        return "Over the app"
    }
    
    static var settingInformationShareTheApp: LocalizedStringKey {
        return "Share this app"
    }
    
    static var settingInformationRateUs: LocalizedStringKey {
        return "Rate us"
    }
    
    static var settingInformationContact: LocalizedStringKey {
        return "Contact"
    }
    
    static var contractTitle: LocalizedStringKey {
        return "Contract"
    }
    
    static var contractName: LocalizedStringKey {
        return "Name"
    }
    
    static var contractAdoptedTrees: LocalizedStringKey {
        return "Adopted trees"
    }
    
    static var changeEmailField: LocalizedStringKey {
        return "New email address"
    }
    
    static var changeEmailAlertTitle: LocalizedStringKey {
        return "Email reset"
    }
    
    static var changeEmailProgress: LocalizedStringKey {
        return "Changing email..."
    }
    
    static var deleteAccountReason: LocalizedStringKey {
        return "Reason"
    }
    
    static var deleteAccountFirstReason: LocalizedStringKey {
        return "Not interested anymore"
    }
    
    static var deleteAccountSecondReason: LocalizedStringKey {
        return "Not convinced"
    }
    
    static var deleteAccountThirdReason: LocalizedStringKey {
        return "Too expensive"
    }
    
    static var deleteAccountFourthReason: LocalizedStringKey {
        return "Others"
    }
    
    static var deleteAccountNote: LocalizedStringKey {
        return "You can only delete your account if you do not have a valid adoption contract"
    }
    
    static var deleteAccountAlertTitle: LocalizedStringKey {
        return "Account deletion"
    }
    
    static var deleteAccountProgress: LocalizedStringKey {
        return "Deleting account..."
    }
}

/* Adoption Screens */
extension Localization {
    static var treeTypesInfo: LocalizedStringKey {
        return "Tree info"
    }
    
    static var treeSelectionFilters: LocalizedStringKey {
        return "Filters"
    }
    
    static var treeSelectionCart: LocalizedStringKey {
        return "Cart"
    }
    
    static var adoptionTitle: LocalizedStringKey {
        return "ADOPTION"
    }
    
    static var adoptionAdd: LocalizedStringKey {
        return "Add"
    }
    
    static var adoptionOverViewTitle: LocalizedStringKey {
        return "Overview"
    }
    
    static var adoptionOverViewTotalPrice: LocalizedStringKey {
        return "Total:"
    }
    
    static var adoptionOverViewCartEmpty: LocalizedStringKey {
        return "Cart is empty , go back to add some trees"
    }
    
    static var adoptionOverViewPersonalSignNote: LocalizedStringKey {
        return "Adding a personal sign for multiple trees is not possible yet. You can still add one for each tree after the adoption."
    }
    
    static var adoptionOverViewPersonalSignAddNote: LocalizedStringKey {
        return "Type personal sign and tick the circle"
    }
    
    static var adoptionOverViewPersonalSignAddLaterNote: LocalizedStringKey {
        return "Personal sign can be added later as well"
    }
    
    static var successfulAdoptionTitle: LocalizedStringKey {
        return "Thank you for your adoption"
    }
    
    static var successfulAdoptionText: LocalizedStringKey {
        return "With your contribution CO2 emissions can be reduced and wildlife and biodiversity will further thrive. Once your tree/s are planted you will be able to track their status."
    }
    
    static var failedAdoptionText: LocalizedStringKey {
        return "Something went wrong! Your adoption has failed"
    }
}

/* Guest Screens */
extension Localization {
    static var homeGuestTitle: LocalizedStringKey {
        return "Why adopting a tree, why ADOPTREE?"
    }
    
    static var homeGuestTress: LocalizedStringKey {
        return "Available trees"
    }
    
    static var homeGuestAdoptionContribution: LocalizedStringKey {
        return "Contribute now by adopting a tree"
    }
    
    static var timelineGuestText: LocalizedStringKey {
        return "Login or adopt a tree to stay up to date with all your tree's achievements and milestones"
    }
    
    static var profileGuestName: LocalizedStringKey {
        return "HELLO YOU!"
    }
}

/* Screens Bar Titles */
extension Localization {
    static var homeTitle: LocalizedStringKey {
        return "HOME"
    }
    
    static var homeTitleText: LocalizedStringKey {
        return "Home"
    }
    
    static var timelineTitle: LocalizedStringKey {
        return "TIMELINE"
    }
    
    static var timelineTitleText: LocalizedStringKey {
        return "Timeline"
    }
    
    static var newsTitle: LocalizedStringKey {
        return "NEWS"
    }
    
    static var newsTitleText: LocalizedStringKey {
        return "News"
    }
    
    static var profileTitle: LocalizedStringKey {
        return "PROFILE"
    }
    
    static var profileTitleText: LocalizedStringKey {
        return "Profile"
    }
    
    static var settingsTitle: LocalizedStringKey {
        return "SETTINGS"
    }
    
    static var settingsTitleText: LocalizedStringKey {
        return "Settings"
    }
}

/* Alerts */
extension Localization {
    static var errorOccurred: LocalizedStringKey {
        return "An error occurred. Please try again!"
    }
    
    static var successfullyEdited: LocalizedStringKey {
        return "Successfully edited"
    }
    
    static var personalSignEmptyAlert: LocalizedStringKey {
        return "Personal sign cannot be empty!"
    }
    
    static var successfulSignPurchase: LocalizedStringKey {
        return "Successfully purchased a sign"
    }
    
    static var successfulContractRenewal: LocalizedStringKey {
        return "Congratulations􀎸 your adoption has been extended by 1 year"
    }
    
    static var contractRenewalConfirm: LocalizedStringKey {
        return "Are you sure you want to extend your adoption?"
    }
    
    static var successfulTourBooking: LocalizedStringKey {
        return "Great! Your tour has been booked"
    }
    
    static var tourCancelingConfirmation: LocalizedStringKey {
        return "Are you sure about cancelling your tour?"
    }
    
    static var successfulCanceledTour: LocalizedStringKey {
        return "Your tour has been cancelled"
    }
    
    static var loginError: LocalizedStringKey {
        return "An error occurred. Please check your username and password!"
    }
    
    static var signupError: LocalizedStringKey {
        return "An error occurred. Username already exists!"
    }
    
    static var adoptionLoginPurchaseError: LocalizedStringKey {
        return "An error occurred. Please click Log in & pay button again!"
    }
    
    static var signupPurchaseError: LocalizedStringKey {
        return "An error occurred. Please click Sign up & pay button again!"
    }
    
    static var successfulPasswordReset: LocalizedStringKey {
        return "Password has been reset"
    }
    
    static var requestPasswordResetError: LocalizedStringKey {
        return "An error has occurred. Please check your username and email!"
    }
    
    static var successfulEmailChange: LocalizedStringKey {
        return "Email has been changed"
    }
    
    static var successfulPasswordChange: LocalizedStringKey {
        return "Password has been changed"
    }
    
    static var successfulAccountDeletion: LocalizedStringKey {
        return "Your account has been deleted! Hope to see you again"
    }
    
    static var contentAlertTitle: LocalizedStringKey {
        return "Network error"
    }
    
    static var contentAlertMessage: LocalizedStringKey {
        return "Could not load the data due to a network error"
    }
}

/* Buttons */
extension Localization {
    static var confirmBtn: LocalizedStringKey {
        return "Confirm"
    }
    
    static var okBtn: LocalizedStringKey {
        return "OK"
    }
    
    static var confirmPayBtn: LocalizedStringKey {
        return "Confirm & pay"
    }
    
    static var yesBtn: LocalizedStringKey {
        return "YES"
    }
    
    static var noBtn: LocalizedStringKey {
        return "NO"
    }
    
    static var cancelBtn: LocalizedStringKey {
        return "Cancel"
    }
    
    static var loginBtn: LocalizedStringKey {
        return "Log in"
    }
    
    static var signupBtn: LocalizedStringKey {
        return "Sign up"
    }
    
    static var loginPayBtn: LocalizedStringKey {
        return "Log in & pay"
    }
    
    static var signupPayBtn: LocalizedStringKey {
        return "Sign up & pay"
    }
    
    static var resetPasswordBtn: LocalizedStringKey {
        return "Reset my password"
    }
    
    static var requestPasswordChangeBtn: LocalizedStringKey {
        return "Request password change"
    }
    
    static var logoutBtn: LocalizedStringKey {
        return "Log out"
    }
    
    static var addMoreBtn: LocalizedStringKey {
        return "Adopt more"
    }
    
    static var payBtn: LocalizedStringKey {
        return "Pay"
    }
    
    static var proceedBtn: LocalizedStringKey {
        return "Proceed"
    }
    
    static var followTreeBtn: LocalizedStringKey {
        return "Follow your tree"
    }
    
    static var goBackBtn: LocalizedStringKey {
        return "Go back"
    }
    
    static var adoptNowBtn: LocalizedStringKey {
        return "Adopt now"
    }
    
    static var tryAgianBtn: LocalizedStringKey {
        return "Try again"
    }
}

/* Textfields */
extension Localization {
    static var firstNameField: LocalizedStringKey {
        return "First name"
    }
    
    static var lastNameField: LocalizedStringKey {
        return "Last name"
    }
    
    static var passwordField: LocalizedStringKey {
        return "Password"
    }
    
    static var confirmPasswordField: LocalizedStringKey {
        return "Confirm password"
    }
    
    static var usernameField: LocalizedStringKey {
        return "Username"
    }
    
    static var emailField: LocalizedStringKey {
        return "Email"
    }
    
    static var newPasswordField: LocalizedStringKey {
        return "New password"
    }
}
