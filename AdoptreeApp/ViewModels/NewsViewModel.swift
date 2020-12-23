//
//  NewsViewModel.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 10/12/2020.
//

import Foundation
import Combine

class NewsViewModel: ObservableObject {
    @Published var contents: [Content] = []
    @Published var informativeContents: [Content] = []
    @Published var anncouncmentContents: [Content] = []
    @Published var aboutContents: [Content] = []
    @Published var tours: [Tour] = []
    @Published var bookedTours: [BookedTour] = []
    private let contentRepository: ContentRepositoryProtocol
    private let tourRepository: TourRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(contentRepository: ContentRepositoryProtocol, tourRepository: TourRepositoryProtocol, userRepository: UserRepositoryProtocol) {
        self.contentRepository = contentRepository
        self.tourRepository = tourRepository
        self.userRepository = userRepository
    }
}

extension NewsViewModel {
    
    func getNewsViewData(of userId: Int64) {
        let contentUrlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .content, using: .get)
        let tourUrlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .tour, using: .get)
        let bookedTourUrlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .bookedtourById(userId), using: .get)
        
        Publishers.CombineLatest3(contentRepository.getContents(using: contentUrlRequest), tourRepository.getTours(using: tourUrlRequest), userRepository.getBookedToursByUser(using: bookedTourUrlRequest))
            .sink(receiveValue: {contents, tours, bookedTours in
                
                switch(contents) {
                    case .failure(let error):
                        switch error {
                            case .decodingError(let decodingError):
                                print(decodingError)
                            case .urlError(let urlError):
                                print(urlError)
                            default:
                                print(error)
                        }
                        
                    case .success(let contents):
                        self.contents = contents.sorted(by: {$0.createdOn > $1.createdOn})
                        self.createContentData()
                }
                
                switch(tours) {
                    case .failure(let error):
                        switch error {
                            case .decodingError(let decodingError):
                                print(decodingError)
                            case .urlError(let urlError):
                                print(urlError)
                            default:
                                print(error)
                        }
                        
                    case .success(let tours):
                        self.tours = tours
                }
                
                switch(bookedTours) {
                    case .failure(let error):
                        switch error {
                            case .decodingError(let decodingError):
                                print(decodingError)
                            case .urlError(let urlError):
                                print(urlError)
                            default:
                                print(error)
                        }
                        
                    case .success(let bookedTours):
                        self.bookedTours = bookedTours
                }
            })
            .store(in: &cancellables)
    }
}

extension NewsViewModel {

    func createContentData() {
        contents.forEach({ content in
            if content.contentType == ContentType.informative.rawValue {
                informativeContents.append(content)
            } else if content.contentType == ContentType.announcement.rawValue {
                anncouncmentContents.append(content)
            } else if content.contentType == ContentType.about.rawValue {
                aboutContents.append(content)
            }
        })
    }
}

extension NewsViewModel {
    
    func bookTour(using tour: Tour, completion: @escaping (Result<BookedTour, RequestError>) -> Void) {
        do {
            let bookedTour = BookedTour(id: nil, tourId: tour.id, userId: 1, userName: "", userEmail: "", bookedDateTime: nil)
            let urlRequest = try ViewModelHelper.buildUrlRequestWithParam(withEndpoint: .bookedtour, using: .post, withParams: bookedTour)
            
            tourRepository.bookTour(using: urlRequest)
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
                    self.bookedTours.append(result)
                    completion(.success(result))
                })
                .store(in: &cancellables)
            
        }catch let encodingError as EncodingError{
            completion(.failure(.encodingError(encodingError)))
        }catch let error{
            completion(.failure(.genericError(error)))
        }
    }
    
    
    func cancelBookedTour(using bookedTourId: Int64, completion: @escaping (Result<HTTPURLResponse, RequestError>) -> Void) {
        
        let urlRequest = ViewModelHelper.buildUrlRequestWithoutParam(withEndpoint: .bookedtourByIdDelete(bookedTourId), using: .delete)
        
        tourRepository.cancelBookedTour(using: urlRequest)
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
            }, receiveValue: {result in
                self.bookedTours.removeAll(where: {$0.id == bookedTourId})
                completion(.success(result))
            })
            .store(in: &cancellables)
    }
}
