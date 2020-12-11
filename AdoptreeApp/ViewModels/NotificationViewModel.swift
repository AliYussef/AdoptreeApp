//
//  NotificationViewModel.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 08/12/2020.
//

import Foundation
import Combine

class NotificationViewModel: ObservableObject {
    static let shared = NotificationViewModel(notificationRepository: NotificationRepository())
    @Published var notificationDevice: NotificationDevice?
    private let userDefaults: UserDefaults
    @Published var notificationObject: NotificationObject {
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
        notificationObject = NotificationObject()
        print("notification view model")
        if !isNotificationObjectPresent() {
            saveNotificationObject()
        }
    }
    
}

extension NotificationViewModel {
    
    
    func isNotificationObjectPresent() -> Bool{
        do {
            notificationObject = try userDefaults.getObject(forKey: notificationKey, castTo: NotificationObject.self)
            return true
        } catch {
            print(error.localizedDescription)
        }
        
        return false
    }
    
    func saveNotificationObject() {
        
        do {
            try userDefaults.setObject(notificationObject, forKey: notificationKey)
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
                                    completion(.failure(.urlError(urlError)))
                                case let decodingError as DecodingError:
                                    completion(.failure(.decodingError(decodingError)))
                                default:
                                    completion(.failure(.genericError(error)))
                            }
                    }
                    
                }, receiveValue: {result in
                    completion(.success(result))
                    self.notificationDevice = result
                })
                .store(in: &cancellables)
            
        }catch let encodingError as EncodingError{
            completion(.failure(.encodingError(encodingError)))
        }catch let error{
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
                                    completion(.failure(.urlError(urlError)))
                                case let decodingError as DecodingError:
                                    completion(.failure(.decodingError(decodingError)))
                                default:
                                    completion(.failure(.genericError(error)))
                            }
                    }
                    
                }, receiveValue: {result in
                    completion(.success(result))
                    self.notificationDevice = result
                })
                .store(in: &cancellables)
            
        }catch let encodingError as EncodingError{
            completion(.failure(.encodingError(encodingError)))
        }catch let error{
            completion(.failure(.genericError(error)))
        }
    }
    
}
