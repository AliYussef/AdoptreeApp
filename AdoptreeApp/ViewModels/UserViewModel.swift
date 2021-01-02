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
    private let keyChain = Keychain()
    private let userDefaults: UserDefaults
    private var accessTokenKey = "accessToken"
    private var refreshTokenKey = "refreshToken"
    private var authenDateKey = "authenDateKey"
    @Published var userShared: UserShared
    private var userKey = "userObject"
    private var cancellables = Set<AnyCancellable>()
    private let userRepository: UserRepositoryProtocol
    @Published var authRequired: Bool = false
    
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
        
        return dateDiff.minute! >= 9 ? false : true
    }
    
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
    
    func getUserSharedObject(){
        do {
            userShared = try userDefaults.getObject(forKey: userKey, castTo: UserShared.self)
            //return true
        } catch {
            print(error.localizedDescription)
        }
        
        //return false
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
    
    func login(user: User, completion: @escaping (Result<LoginResponse, RequestError>) -> Void) {
        
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
                    print(self.authenDate)
                    completion(.success(result))
                })
                .store(in: &cancellables)
            
        }catch let encodingError as EncodingError{
            completion(.failure(.encodingError(encodingError)))
        }catch let error{
            completion(.failure(.genericError(error)))
        }
    }
    
    func refreshToken(completion: @escaping (Result<RefreshTokenResponse, RequestError>) -> Void) {
        let fullUrl = BaseURL.url + ApiEndPoint.refreshToken.description
        let url = URL(string: fullUrl)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let refreshToken = UserViewModel.shared.refreshToken {
            urlRequest.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        }
        urlRequest.httpMethod = RequestMethod.post.rawValue
        
        userRepository.refreshToken(using: urlRequest)
            .sink(receiveCompletion: {result in
                switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        switch error {
                            case let urlError as URLError:
                                self.accessToken = nil
                                completion(.failure(.urlError(urlError)))
                            case let decodingError as DecodingError:
                                self.accessToken = nil
                                completion(.failure(.decodingError(decodingError)))
                            default:
                                self.accessToken = nil
                                completion(.failure(.genericError(error)))
                        }
                }
            }, receiveValue: {result in
                self.authenDate = String(Date().timeIntervalSince1970)
                self.accessToken = result.accessToken
                self.refreshToken = result.refreshToken
                completion(.success(result))
            })
            .store(in: &cancellables)
    }
    
    func logout() {
        accessToken = nil
    }
}

extension UserViewModel {
    
    func getUserById(for userId: Int64, completion: @escaping(Result<User, RequestError>) -> Void) {
       
        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .userById(userId), using: .get)
        
        userRepository.getUserById(using: urlRequest)
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
                print(self.userShared)
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
    
    func deleteUserAccount(completion: @escaping (Result<HTTPURLResponse, RequestError>) -> Void) {
        
        guard userShared.id != nil else {
            return
        }
        
        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .userById(userShared.id!), using: .delete)
        
        userRepository.deleteUserAccount(using: urlRequest)
            .sink(receiveCompletion: {result in
                switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        switch error {
                            case let urlError:
                                completion(.failure(.urlError(urlError)))
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
