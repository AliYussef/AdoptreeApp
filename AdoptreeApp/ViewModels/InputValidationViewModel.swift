//
//  InputValidationViewModel.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 21/12/2020.
//

import Foundation
import Combine

class InputValidationViewModel: ObservableObject {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var username = ""
    @Published var password = "" {
        didSet {
            passwords[0] = password
        }
    }
    @Published var confirmPassword = "" {
        didSet {
            passwords[1] = confirmPassword
        }
    }
    @Published var passwords: [String] = ["0","1"]
    
    
    lazy var firstNameValidation: ValidationPublisher = {
        $firstName.nonEmptyValidator("First name must be provided")
    }()
    
    lazy var lastNameValidation: ValidationPublisher = {
        $lastName.nonEmptyValidator("Last name must be provided")
    }()
    
    lazy var emailEmptyValidation: ValidationPublisher = {
        $email.nonEmptyValidator("Email must not be empty")
    }()
    
    lazy var emailValidation: ValidationPublisher = {
        $email.matcherValidation(emailRegEx, "Invalid email")
    }()
    
    lazy var usernameValidation: ValidationPublisher = {
        $username.nonEmptyValidator("Username must not be empty")
    }()
    
    lazy var passwordValidation: ValidationPublisher = {
        $password.nonEmptyValidator("Password must not be empty")
    }()
    
    lazy var confirmPasswordValidation: ValidationPublisher = {
        $confirmPassword.nonEmptyValidator("Confirm Password must not be empty")
    }()
    
    lazy var confirmPasswordMatchingValidation: ValidationPublisher = {
        $passwords.passwordMatcherValidation(password, "Passwords do not match")
    }()
    
    lazy var firstBlockValidation: ValidationPublisher = {
        Publishers.CombineLatest4(
            firstNameValidation,
            lastNameValidation,
            emailValidation,
            emailEmptyValidation
        ).map { v1, v2, v3, v4 in
            // print("firstNameValidation: \(v1)")
            // print("lastNameValidation: \(v2)")
            //print("emailValidation: \(v3)")
            //print("emailEmptyValidation: \(v4)")
            return [v1, v2, v3, v4].allSatisfy { $0.isSuccess } ? .success : .failure(message: "")
        }.eraseToAnyPublisher()
    }()
    
    lazy var secondBlockValidation: ValidationPublisher = {
        Publishers.CombineLatest4(
            usernameValidation,
            passwordValidation,
            confirmPasswordValidation,
            confirmPasswordMatchingValidation
        ).map { v1, v2, v3, v4 in
            // print("usernameValidation: \(v1)")
            //print("passwordValidation: \(v2)")
            // print("confirmPasswordValidation: \(v3)")
            //print("confirmPasswordMatchingValidation: \(v4)")
            return [v1, v2, v3, v4].allSatisfy {
                $0.isSuccess } ? .success : .failure(message: "")
        }.eraseToAnyPublisher()
    }()
    
    lazy var allValidation: ValidationPublisher = {
        Publishers.CombineLatest(
            firstBlockValidation,
            secondBlockValidation
        ).map { v1, v2 in
            return [v1, v2].allSatisfy { $0.isSuccess } ? .success : .failure(message: "")
        }.eraseToAnyPublisher()
    }()
    
    lazy var resetPasswordValidation: ValidationPublisher = {
        Publishers.CombineLatest(
            confirmPasswordValidation,
            confirmPasswordMatchingValidation
        ).map { v1, v2 in
            return [v1, v2].allSatisfy { $0.isSuccess } ? .success : .failure(message: "")
        }.eraseToAnyPublisher()
    }()
    
    lazy var requestResetPasswordValidation: ValidationPublisher = {
        Publishers.CombineLatest3(
            usernameValidation,
            emailEmptyValidation,
            emailValidation
        ).map { v1, v2, v3 in
            return [v1, v2, v3].allSatisfy { $0.isSuccess } ? .success : .failure(message: "")
        }.eraseToAnyPublisher()
    }()
    
    lazy var changeEmailValidation: ValidationPublisher = {
        Publishers.CombineLatest3(
            emailEmptyValidation,
            emailValidation,
            passwordValidation
        ).map { v1, v2, v3 in
            return [v1, v2, v3].allSatisfy { $0.isSuccess } ? .success : .failure(message: "")
        }.eraseToAnyPublisher()
    }()
    
    lazy var loginValidation: ValidationPublisher = {
        Publishers.CombineLatest(
            usernameValidation,
            passwordValidation
        ).map { v1, v2 in
            return [v1, v2].allSatisfy { $0.isSuccess } ? .success : .failure(message: "")
        }.eraseToAnyPublisher()
    }()
    
}
