//
//  ValidationPublishers.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 20/12/2020.
//

import Foundation
import Combine
import Regex

typealias ValidationErrorClosure = () -> String
typealias ValidationPublisher = AnyPublisher<InputValidation, Never>

class ValidationPublishers {

    static func nonEmptyValidation(for publisher: Published<String>.Publisher,
                                   errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return publisher.map { value in
            guard value.count > 0 else {
                return .failure(message: errorMessage())
            }
            return .success
        }
        .dropFirst()
        .eraseToAnyPublisher()
    }
    
    static func matcherValidation(for publisher: Published<String>.Publisher,
                                  withPattern pattern: Regex,
                                  errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return publisher.map { value in
            guard pattern.matches(value) else {
                return .failure(message: errorMessage())
            }
            return .success
        }
        .dropFirst()
        .eraseToAnyPublisher()
    }
    
    static func passwordMatcherValidation(for publisher: Published<[String]>.Publisher,
                                          password: String,
                                          errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return publisher.map { value in
            if value[1] != "1" {
                guard value[0] == value[1] else {
                    return .failure(message: errorMessage())
                }
            }
            return .success
        }
        .dropFirst()
        .eraseToAnyPublisher()
    }
}

extension Published.Publisher where Value == String {
    
    func nonEmptyValidator(_ errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return ValidationPublishers.nonEmptyValidation(for: self, errorMessage: errorMessage())
    }
    
    func matcherValidation(_ pattern: String, _ errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return ValidationPublishers.matcherValidation(for: self, withPattern: pattern.r!, errorMessage: errorMessage())
    }
    
}

extension Published.Publisher where Value == [String] {
    
    func passwordMatcherValidation(_ password: String, _ errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return ValidationPublishers.passwordMatcherValidation(for: self, password: password, errorMessage: errorMessage())
    }
    
}
