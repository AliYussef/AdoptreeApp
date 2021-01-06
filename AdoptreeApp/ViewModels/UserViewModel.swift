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
    static let shared = UserViewModel(userRepository: UserRepository())
    @Published var isAuthenticated: Bool = false
    @Published var tempAccessToken: String = ""
    @Published var isGuest: Bool = false
    @Published var forgetPasswordToken: String = ""
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
                //isAuthenticated = false
                return
            }
            try? keyChain.set(accessToken, key: accessTokenKey)
            //isAuthenticated = true
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
                                    completion(.failure(.urlError(urlError)))
                                case let decodingError as DecodingError:
                                    completion(.failure(.decodingError(decodingError)))
                                default:
                                    completion(.failure(.genericError(error)))
                            }
                    }
                }, receiveValue: { result in
                    self.authenDate = String(Date().timeIntervalSince1970)
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
                                print(urlError)
                                completion(.failure(.urlError(urlError)))
                            case let decodingError as DecodingError:
                                print(decodingError)
                                completion(.failure(.decodingError(decodingError)))
                            default:
                                print(error)
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
                    self.forgetPasswordToken = result
                    completion(.success(result))
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
                                    completion(.failure(.urlError(urlError)))
                                case let decodingError as DecodingError:
                                    completion(.failure(.decodingError(decodingError)))
                                default:
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
            completion(.failure(.encodingError(encodingError)))
        } catch let error{
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
                                completion(.failure(.urlError(urlError)))
                            default:
                                completion(.failure(.genericError(error)))
                        }
                }
            }, receiveValue: { result in
                completion(.success(result))
                //self.userShared = UserShared(id: nil, firstname: nil, lastname: nil, username: nil, email: nil)
                //self.saveUserSharedObject()
                //self.logout()
            })
            .store(in: &cancellables)
    }
}
