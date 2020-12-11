//
//  TimelineViewModel.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation
import Combine

class TimelineViewModel: ObservableObject {
    @Published var telemetries: [Telemetry] = []
    @Published var sequestrations: [Sequestration] = []
    private let telemetryRepository: TelemetryRepositoryProtocol
    private let treeRepository: TreeRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(telemetryRepository: TelemetryRepositoryProtocol, treeRepository: TreeRepositoryProtocol) {
        self.telemetryRepository = telemetryRepository
        self.treeRepository = treeRepository
    }
}
extension TimelineViewModel {
    
    func getTimeLineData(using treeId:Int64) {
        let telemetryUrlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .telemetryById(treeId), using: .get)
        let sequestrationUrlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .sequestration(treeId), using: .get)
        
        Publishers.CombineLatest(telemetryRepository.getTelemetryByTree(using: telemetryUrlRequest), treeRepository.getTreeSequestraion(using: sequestrationUrlRequest))
            .sink(receiveValue: { telemetries, sequestrations in
                switch(telemetries) {
                    case .failure(let error):
                        switch error {
                            case .decodingError(let decodingError):
                                print(decodingError)
                            case .urlError(let urlError):
                                print(urlError)
                            default:
                                print(error)
                        }
                        
                    case .success(let telemetries):
                        //since the response is array but there is always one element only
                        if let telemetry = telemetries.first {
                            self.telemetries.append(telemetry)
                        }
                }
                
                switch(sequestrations) {
                    case .failure(let error):
                        switch error {
                            case .decodingError(let decodingError):
                                print(decodingError)
                            case .urlError(let urlError):
                                print(urlError)
                            default:
                                print(error)
                        }
                        
                    case .success(let sequestrations):
                        self.sequestrations.append(Sequestration(treeId: treeId, sequestration: sequestrations))
                }
            })
            .store(in: &cancellables)
        
        //            .sink(receiveCompletion: {result in
        //                switch result {
        //                    case .finished:
        //                        break
        //                    case .failure(let error):
        //                        switch error {
        //                            case let urlError as URLError:
        //                                print(urlError)
        //                            //completion(.failure(.urlError(urlError)))
        //                            case let decodingError as DecodingError:
        //                                print(decodingError)
        //                            //completion(.failure(.decodingError(decodingError)))
        //                            default:
        //                                print(error)
        //                            //completion(.failure(.genericError(error)))
        //                        }
        //                }
        //
        //            }, receiveValue: { telemetries, sequestrations in
        //                if let telemetry = telemetries.first {
        //                    self.telemetries.append(telemetry)
        //                }
        //                self.sequestrations.append(Sequestration(treeId: treeId, sequestration: sequestrations))
        //            })
        //            .store(in: &cancellables)
    }
}

extension TimelineViewModel {
    
//    func getTelemetryByTree(using treeId:Int64 ,completion: @escaping (Result<[Telemetry], RequestError>) -> Void) {
//
//        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .telemetryById(treeId), using: .get)
//
//        telemetryRepository.getTelemetryByTree(using: urlRequest)
//            .sink(receiveCompletion: {result in
//                switch result {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        switch error {
//                            case let urlError as URLError:
//                                print(urlError)
//                                completion(.failure(.urlError(urlError)))
//                            case let decodingError as DecodingError:
//                                print(decodingError)
//                                completion(.failure(.decodingError(decodingError)))
//                            default:
//                                print(error)
//                                completion(.failure(.genericError(error)))
//                        }
//                }
//
//            }, receiveValue: {result in
//                completion(.success(result))
//                self.telemetries.append(contentsOf: result)
//            })
//            .store(in: &cancellables)
//    }
}

extension TimelineViewModel {
    
//    func getTreeSequestraion(using treeId:Int64, completion: @escaping (Result<[Double], RequestError>) -> Void) {
//
//        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .sequestration(treeId), using: .get)
//
//        treeRepository.getTreeSequestraion(using: urlRequest)
//            .sink(receiveCompletion: {result in
//                switch result {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        switch error {
//                            case let urlError as URLError:
//                                print(urlError)
//                                completion(.failure(.urlError(urlError)))
//                            case let decodingError as DecodingError:
//                                print(decodingError)
//                                completion(.failure(.decodingError(decodingError)))
//                            default:
//                                print(error)
//                                completion(.failure(.genericError(error)))
//                        }
//                }
//
//            }, receiveValue: {result in
//                completion(.success(result))
//                self.sequestrations.append(Sequestration(treeId: treeId, sequestration: result))
//            })
//            .store(in: &cancellables)
//    }
    
}
