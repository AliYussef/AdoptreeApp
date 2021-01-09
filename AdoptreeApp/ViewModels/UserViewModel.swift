//
//  UserViewModel.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine
import KeychainAccess
import os

class UserViewModel: ObservableObject {
    static let shared = UserViewModel(userRepository: UserRepository())
    @Published var isAuthenticated: Bool = false
    @Published var tempAccessToken: String = ""
    @Published var isGuest: Bool = false
    @Published var isforgetPasswordTokenSent: Bool = false
    @Published var userShared: UserShared
    @Published var authRequired: Bool = false
    private let keyChain = Keychain()
    private let userDefaults: UserDefaults
    private let userRepository: UserRepositoryProtocol
    private var accessTokenKey = "accessToken"
    private var refreshTokenKey = "refreshToken"
    private var authenDateKey = "authenDateKey"
    private var userKey = "userObject"
    private let refreshTokenExpTime = 9
    private var cancellables = Set<AnyCancellable>()
    
    private init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
        userDefaults = UserDefaults.standard
        userShared = UserShared(id: nil, firstname: nil, lastname: nil, username: nil, email: nil)
        getUserSharedObject()
        isAuthenticated = accessToken != nil
    }
}

extension UserViewModel {
    
    var accessToken: String? {
        get {
            try? keyChain.get(accessTokenKey)
        }
        set(newValue) {
            guard let accessToken = newValue else {
                try? keyChain.remove(accessTokenKey)
                return
            }
            try? keyChain.set(accessToken, key: accessTokenKey)
        }
    }
    
    var refreshToken: String? {
        get {
            try? keyChain.get(refreshTokenKey)
        }
        set(newValue) {
            guard let refreshToken = newValue else {
                try? keyChain.remove(refreshTokenKey)
                return
            }
            try? keyChain.set(refreshToken, key: refreshTokenKey)
        }
    }
    
    var authenDate: String? {
        get {
            try? keyChain.get(authenDateKey)
        }
        set(newValue) {
            guard let authenDate = newValue else {
                try? keyChain.remove(authenDateKey)
                return
            }
            try? keyChain.set(authenDate, key: authenDateKey)
        }
    }
    
    func checkTokenValidity() -> Bool {
        var dateDiff = DateComponents()
        
        if let authenticationTimeString = authenDate {
            if let authenticationTime = Double(authenticationTimeString) {
                dateDiff = Calendar.current.dateComponents([.minute], from: Date(timeIntervalSince1970: authenticationTime), to: Date())
            }
        }
        
        guard dateDiff.minute != nil else {
            return false
        }
        
        return dateDiff.minute! >= refreshTokenExpTime ? false : true
    }
    
    func getUserSharedObject(){
        
        do {
            userShared = try userDefaults.getObject(forKey: userKey, castTo: UserShared.self)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveUserSharedObject() {
        
        do {
            try userDefaults.setObject(userShared, forKey: userKey)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

extension UserViewModel {
    
    func registerUser(user: User, completion: @escaping (Result<User, RequestError>) -> Void) {
        
        do {
            
            let urlRequest = try ViewModelHelper.buildUrlRequestWithParam(withEndpoint: .register, using: .post, withParams: user)
            
            userRepository.registerUser(using: urlRequest)
                .sink(receiveCompletion: {result in
                    switch result {
                        case .finished:
                            break
                        case .failure(let error):
                            switch error {
                                case let urlError as URLError:
                                    os_log("Url error", type: .error, urlError.localizedDescription)
                                    completion(.failure(.urlError(urlError)))
                                case let decodingError as DecodingError:
                                    os_log("Decoding error", type: .error, decodingError.localizedDescription)
                                    completion(.failure(.decodingError(decodingError)))
                                default:
                                    os_log("Error", type: .error, error.localizedDescription)
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
    
    func login(user: UserLogin, completion: @escaping (Result<LoginResponse, RequestError>) -> Void) {
        
        do {
            
            let urlRequest = try ViewModelHelper.buildUrlRequestWithParam(withEndpoint: .login, using: .post, withParams: user)
            
            userRepository.login(using: urlRequest)
                .sink(receiveCompletion: {result in
                    switch result {
                        case .finished:
                            break
                        case .failure(let error):
                            switch error {
                                case let urlError as URLError:
                                    os_log("Url error", type: .error, urlError.localizedDescription)
                                    completion(.failure(.urlError(urlError)))
                                case let decodingError as DecodingError:
                                    os_log("Decoding error", type: .error, decodingError.localizedDescription)
                                    completion(.failure(.decodingError(decodingError)))
                                default:
                                    os_log("Error", type: .error, error.localizedDescription)
                                    completion(.failure(.genericError(error)))
                            }
                    }
                }, receiveValue: { result in
                    self.authenDate = String(Date().timeIntervalSince1970)
                    completion(.success(result))
                })
                .store(in: &cancellables)
            
        }catch let encodingError as EncodingError{
            os_log("Encoding error", type: .error, encodingError.localizedDescription)
            completion(.failure(.encodingError(encodingError)))
        }catch let error{
            os_log("Error", type: .error, error.localizedDescription)
            completion(.failure(.genericError(error)))
        }
    }
    
    func logout() {
        accessToken = nil
        refreshToken = nil
        userShared = UserShared(id: nil, firstname: nil, lastname: nil, username: nil, email: nil)
        saveUserSharedObject()
        isAuthenticated = false
    }
}

extension UserViewModel {
    
    func getLoggedinUser(completion: @escaping(Result<User, RequestError>) -> Void) {
        
        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .loggedInUser, using: .get)
        
        userRepository.getLoggedinUser(using: urlRequest)
            .sink(receiveCompletion: {result in
                switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        switch error {
                            case let urlError as URLError:
                                os_log("Url error", type: .error, urlError.localizedDescription)
                                completion(.failure(.urlError(urlError)))
                            case let decodingError as DecodingError:
                                os_log("Decoding error", type: .error, decodingError.localizedDescription)
                                completion(.failure(.decodingError(decodingError)))
                            default:
                                os_log("Error", type: .error, error.localizedDescription)
                                completion(.failure(.genericError(error)))
                        }
                }
            }, receiveValue: {result in
                self.userShared = UserShared(id: result.id, firstname: result.firstname, lastname: result.lastname, username: result.username, email: result.email)
                self.saveUserSharedObject()
                completion(.success(result))
            })
            .store(in: &cancellables)
    }
}

extension UserViewModel {
    
    func forgetPassword(forgetPasswordBody: ForgetPasswordBody, completion: @escaping (Result<Data, RequestError>) -> Void) {
        
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
                                    os_log("Url error", type: .error, urlError.localizedDescription)
                                    completion(.failure(.urlError(urlError)))
                                case let decodingError as DecodingError:
                                    os_log("Decoding error", type: .error, decodingError.localizedDescription)
                                    completion(.failure(.decodingError(decodingError)))
                                default:
                                    os_log("Error", type: .error, error.localizedDescription)
                                    completion(.failure(.genericError(error)))
                            }
                    }
                }, receiveValue: {result in
                    self.isforgetPasswordTokenSent = true
                    completion(.success(result))
                })
                .store(in: &cancellables)
            
        }catch let encodingError as EncodingError{
            os_log("Encoding error", type: .error, encodingError.localizedDescription)
            completion(.failure(.encodingError(encodingError)))
        }catch let error{
            os_log("Error", type: .error, error.localizedDescription)
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
                                    os_log("Url error", type: .error, urlError.localizedDescription)
                                    completion(.failure(.urlError(urlError)))
                                case let decodingError as DecodingError:
                                    os_log("Decoding error", type: .error, decodingError.localizedDescription)
                                    completion(.failure(.decodingError(decodingError)))
                                default:
                                    os_log("Error", type: .error, error.localizedDescription)
                                    completion(.failure(.genericError(error)))
                            }
                    }
                }, receiveValue: {result in
                    completion(.success(result))
                    self.isforgetPasswordTokenSent = false
                })
                .store(in: &cancellables)
            
        }catch let encodingError as EncodingError{
            os_log("Encoding error", type: .error, encodingError.localizedDescription)
            completion(.failure(.encodingError(encodingError)))
        }catch let error{
            os_log("Error", type: .error, error.localizedDescription)
            completion(.failure(.genericError(error)))
        }
    }
}

extension UserViewModel {
    
    func updateUserAccount(user: User, completion: @escaping (Result<User, RequestError>) -> Void) {
        do {
            let urlRequest = try ViewModelHelper.buildUrlRequestWithParam(withEndpoint: .user, using: .put, withParams: user)
            
            userRepository.updateUserAccount(using: urlRequest)
                .sink(receiveCompletion: {result in
                    switch result {
                        case .finished:
                            break
                        case .failure(let error):
                            switch error {
                                case let urlError as URLError:
                                    os_log("Url error", type: .error, urlError.localizedDescription)
                                    completion(.failure(.urlError(urlError)))
                                case let decodingError as DecodingError:
                                    os_log("Decoding error", type: .error, decodingError.localizedDescription)
                                    completion(.failure(.decodingError(decodingError)))
                                default:
                                    os_log("Error", type: .error, error.localizedDescription)
                                    completion(.failure(.genericError(error)))
                            }
                    }
                }, receiveValue: { result in
                    self.userShared = UserShared(id: result.id, firstname: result.firstname, lastname: result.lastname, username: result.username, email: result.email)
                    self.saveUserSharedObject()
                    completion(.success(result))
                })
                .store(in: &cancellables)
            
        } catch let encodingError as EncodingError{
            os_log("Encoding error", type: .error, encodingError.localizedDescription)
            completion(.failure(.encodingError(encodingError)))
        } catch let error{
            os_log("Error", type: .error, error.localizedDescription)
            completion(.failure(.genericError(error)))
        }
    }
    
    func deleteUserAccount(completion: @escaping (Result<Data, RequestError>) -> Void) {
        
        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .user, using: .delete)
        
        userRepository.deleteUserAccount(using: urlRequest)
            .sink(receiveCompletion: {result in
                switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        switch error {
                            case let urlError as URLError:
                                os_log("Url error", type: .error, urlError.localizedDescription)
                                completion(.failure(.urlError(urlError)))
                            default:
                                os_log("Error", type: .error, error.localizedDescription)
                                completion(.failure(.genericError(error)))
                        }
                }
            }, receiveValue: { result in
                completion(.success(result))
                self.logout()
            })
            .store(in: &cancellables)
    }
}
