//
//  UserViewModel.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine
import KeychainAccess

class UserViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var forgetPasswordToken: String = ""
    private let keyChain = Keychain()
    private var accessTokenKey = "accessToken"
    private var cancellables = Set<AnyCancellable>()
    private let userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
        // when starting the app to check if accessToken not equal to nil then set authenticated to true
        isAuthenticated = accessToken != nil
    }
}

extension UserViewModel {
    
    var accessToken: String? {
        get {
            try? keyChain.get(accessTokenKey)
        }
        set(newValue) {
            //here check the value of newValue
            // if it is string or int or hold something then the else will be skipped
            // but if newValue does not hold any value or if nil then else will be executed and user will be logged out
            guard let accessToken = newValue else {
                try? keyChain.remove(accessTokenKey)
                isAuthenticated = false
                return
            }
            try? keyChain.set(accessToken, key: accessTokenKey)
            isAuthenticated = true
        }
    }
}

extension UserViewModel {
    
    func registerUser(user: User, completion: @escaping (Result<LoginResponse, RequestError>) -> Void) {
        
        do {
            
            let urlRequest = try ViewModelHelper.buildUrlRequestWithParam(withEndpoint: .user, using: .post, withParams: user)
            
            userRepository.login(using: urlRequest)
                .sink(receiveCompletion: {result in
                    switch result {
                        case .finished:
                            break
                        case .failure(let error):
                            switch error {
                                case let urlError as URLError:
                                    completion(.failure(.urlError(urlError)))
                                case let decodingError as DecodingError:
                                    completion(.failure(.decodingError(decodingError)))
                                default:
                                    completion(.failure(.genericError(error)))
                            }
                    }
                }, receiveValue: {result in
                    completion(.success(result))
                })
                .store(in: &cancellables)
            
        }catch let encodingError as EncodingError{
            completion(.failure(.encodingError(encodingError)))
        }catch let error{
            completion(.failure(.genericError(error)))
        }
    }
    
    func login(user: User, completion: @escaping (Result<LoginResponse, RequestError>) -> Void) {
        
        do {
            
            let urlRequest = try ViewModelHelper.buildUrlRequestWithParam(withEndpoint: .user, using: .post, withParams: user)
            
            userRepository.login(using: urlRequest)
                .sink(receiveCompletion: {result in
                    switch result {
                        case .finished:
                            break
                        case .failure(let error):
                            switch error {
                                case let urlError as URLError:
                                    completion(.failure(.urlError(urlError)))
                                case let decodingError as DecodingError:
                                    completion(.failure(.decodingError(decodingError)))
                                default:
                                    completion(.failure(.genericError(error)))
                            }
                    }
                }, receiveValue: {result in
                    completion(.success(result))
                })
                .store(in: &cancellables)
            
        }catch let encodingError as EncodingError{
            completion(.failure(.encodingError(encodingError)))
        }catch let error{
            completion(.failure(.genericError(error)))
        }
    }
    
    func logout() {
        accessToken = nil
    }
}

extension UserViewModel {
    
    func forgetPassword(forgetPasswordBody: ForgetPasswordBody, completion: @escaping (Result<String, RequestError>) -> Void) {
        
        do {
            
            let urlRequest = try ViewModelHelper.buildUrlRequestWithParam(withEndpoint: .forgetpassword, using: .post, withParams: forgetPasswordBody)
            
            userRepository.forgetPassword(using: urlRequest)
                .sink(receiveCompletion: {result in
                    switch result {
                        case .finished:
                            break
                        case .failure(let error):
                            switch error {
                                case let urlError as URLError:
                                    completion(.failure(.urlError(urlError)))
                                case let decodingError as DecodingError:
                                    completion(.failure(.decodingError(decodingError)))
                                default:
                                    completion(.failure(.genericError(error)))
                            }
                    }
                }, receiveValue: {result in
                    completion(.success(result))
                    self.forgetPasswordToken = result
                })
                .store(in: &cancellables)
            
        }catch let encodingError as EncodingError{
            completion(.failure(.encodingError(encodingError)))
        }catch let error{
            completion(.failure(.genericError(error)))
        }
    }
    
    func resetPassword(resetPasswordBody: ResetPasswordBody, completion: @escaping (Result<User, RequestError>) -> Void) {
        
        do {
            
            let urlRequest = try ViewModelHelper.buildUrlRequestWithParam(withEndpoint: .resetpassword, using: .post, withParams: resetPasswordBody)
            
            userRepository.resetPassword(using: urlRequest)
                .sink(receiveCompletion: {result in
                    switch result {
                        case .finished:
                            break
                        case .failure(let error):
                            switch error {
                                case let urlError as URLError:
                                    completion(.failure(.urlError(urlError)))
                                case let decodingError as DecodingError:
                                    completion(.failure(.decodingError(decodingError)))
                                default:
                                    completion(.failure(.genericError(error)))
                            }
                    }
                }, receiveValue: {result in
                    completion(.success(result))
                })
                .store(in: &cancellables)
            
        }catch let encodingError as EncodingError{
            completion(.failure(.encodingError(encodingError)))
        }catch let error{
            completion(.failure(.genericError(error)))
        }
    }
    
}
