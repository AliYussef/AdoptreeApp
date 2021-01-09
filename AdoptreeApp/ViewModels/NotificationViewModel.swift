//
//  NotificationViewModel.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 08/12/2020.
//

import Foundation
import Combine
import os

class NotificationViewModel: ObservableObject {
    static let shared = NotificationViewModel(notificationRepository: NotificationRepository())
    @Published var notificationDevice: NotificationDevice?
    private let userDefaults: UserDefaults
    @Published var notificationObject: NotificationObject {
        didSet {
            saveNotificationObject()
        }
    }
    @Published var languagesIndex = 0 {
        didSet {
            saveNotificationObject()
        }
    }
    private var notificationKey = "notificationObject"
    private let notificationRepository: NotificationRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private init(notificationRepository: NotificationRepositoryProtocol) {
        self.notificationRepository = notificationRepository
        userDefaults = UserDefaults.standard
        
        notificationObject = NotificationObject(language: Locale.current.languageCode ?? "en")
        if !isNotificationObjectPresent() {
            saveNotificationObject()
        }
    }
    
}

extension NotificationViewModel {
    
    
    func isNotificationObjectPresent() -> Bool{
        do {
            notificationObject = try userDefaults.getObject(forKey: notificationKey, castTo: NotificationObject.self)
            
            if notificationObject.language == "en" {
                languagesIndex = 0
            } else {
                languagesIndex = 1
                
            }
            return true
        } catch {
            print(error.localizedDescription)
        }
        
        return false
    }
    
    func saveNotificationObject() {
        
        do {
            var notificationObjectTemp = NotificationObject(growth: notificationObject.growth, humidity: notificationObject.humidity, temperature: notificationObject.temperature, co2Reduction: notificationObject.co2Reduction, co2ReductionTip: notificationObject.co2ReductionTip, event: notificationObject.event, language: notificationObject.language)
            
            if languagesIndex == 0 {
                notificationObjectTemp.language = "en"
            } else {
                notificationObjectTemp.language = "ln"
            }
            
            try userDefaults.setObject(notificationObjectTemp, forKey: notificationKey)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension NotificationViewModel {
    
    func createNotificationDevice(notificationDevice: NotificationDevice, completion: @escaping (Result<NotificationDevice, RequestError>) -> Void) {
        
        do {
            let urlRequest = try ViewModelHelper.buildUrlRequestWithParam(withEndpoint: .notifydevice, using: .post, withParams: notificationDevice)
            
            notificationRepository.createNotificationDevice(using: urlRequest)
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
                    self.notificationDevice = result
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
    
    
    func updateNotificationDevice(notificationDevice: NotificationDevice, completion: @escaping (Result<NotificationDevice, RequestError>) -> Void) {
        
        do {
            let urlRequest = try ViewModelHelper.buildUrlRequestWithParam(withEndpoint: .notifydevice, using: .put, withParams: notificationDevice)
            
            notificationRepository.updateNotificationDevice(using: urlRequest)
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
                    self.notificationDevice = result
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
