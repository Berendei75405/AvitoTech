//
//  NetworkService.swift
//  AvitoTech
//
//  Created by Novgorodcev on 13/11/2024.
//

import Foundation
import Combine

final class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    private var cancellable = Set<AnyCancellable>()
    
    //MARK: - makeRequest
    func makeRequest<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        //издатель
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        publisher.sink { result in
            switch result {
            case .finished:
                print("finished!")
            case .failure(let error):
                completion(.failure(error))
            }
        } receiveValue: { data in
            completion(.success(data))
        }.store(in: &cancellable)
    }
}
