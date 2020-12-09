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
    @Published var sequestrations: [Double] = []
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
            .sink(receiveCompletion: {result in
                switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        switch error {
                            case let urlError as URLError:
                                print(urlError)
                            //completion(.failure(.urlError(urlError)))
                            case let decodingError as DecodingError:
                                print(decodingError)
                            //completion(.failure(.decodingError(decodingError)))
                            default:
                                print(error)
                            //completion(.failure(.genericError(error)))
                        }
                }
                
            }, receiveValue: { telemetries, sequestrations in
                self.telemetries.append(contentsOf: telemetries)
                self.sequestrations.append(contentsOf: sequestrations)
            })
            .store(in: &cancellables)
    }
}

extension TimelineViewModel {
    
    func getTelemetryByTree(using treeId:Int64 ,completion: @escaping (Result<[Telemetry], RequestError>) -> Void) {
        
        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .telemetryById(treeId), using: .get)
        
        telemetryRepository.getTelemetryByTree(using: urlRequest)
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
                completion(.success(result))
                self.telemetries.append(contentsOf: result)
            })
            .store(in: &cancellables)
    }
}

extension TimelineViewModel {
    
    func getTreeSequestraion(using treeId:Int64, completion: @escaping (Result<[Double], RequestError>) -> Void) {
        
        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .sequestration(treeId), using: .get)
        
        treeRepository.getTreeSequestraion(using: urlRequest)
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
                completion(.success(result))
                self.sequestrations = result
            })
            .store(in: &cancellables)
    }
    
}
