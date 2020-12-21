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
    
    // Validates whether a string property is non-empty.
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
    
    // Validates whether a string matches a regular expression.
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
    
    // Validates whether a string matches a regular expression.
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
    
    // Validates whether a date falls between two other dates. If one of
    // the bounds isn't provided, a suitable distant detail is used.
//    static func dateValidation(for publisher: Published<Date>.Publisher,
//                               afterDate after: Date = .distantPast,
//                               beforeDate before: Date = .distantFuture,
//                               errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
//        return publisher.map { date in
//            return date > after && date < before ? .success : .failure(message: errorMessage())
//        }.eraseToAnyPublisher()
//    }
//
}

extension Published.Publisher where Value == String {
    
    func nonEmptyValidator(_ errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return ValidationPublishers.nonEmptyValidation(for: self, errorMessage: errorMessage())
    }
    
    func matcherValidation(_ pattern: String, _ errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return ValidationPublishers.matcherValidation(for: self, withPattern: pattern.r!, errorMessage: errorMessage())
    }
    
//    func passwordMatcherValidation(_ password: String, _ errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
//        return ValidationPublishers.passwordMatcherValidation(for: self, password: password, errorMessage: errorMessage())
//    }
    
}

extension Published.Publisher where Value == [String] {
    
    func passwordMatcherValidation(_ password: String, _ errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
        return ValidationPublishers.passwordMatcherValidation(for: self, password: password, errorMessage: errorMessage())
    }
    
}

//extension Published.Publisher where Value == Date {
//    func dateValidation(afterDate after: Date = .distantPast,
//                        beforeDate before: Date = .distantFuture,
//                        errorMessage: @autoclosure @escaping ValidationErrorClosure) -> ValidationPublisher {
//        return ValidationPublishers.dateValidation(for: self, afterDate: after, beforeDate: before, errorMessage: errorMessage())
//    }
//}
