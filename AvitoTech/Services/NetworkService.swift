//
//  NetworkService.swift
//  AvitoTech
//
//  Created by Novgorodcev on 13/11/2024.
//

import Foundation
import Combine

//MARK: - NetworkError
enum NetworkError: Error {
    case errorWithDescription(String)
    case error(Error)
}

final class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    private var cancellable = Set<AnyCancellable>()
    
    //MARK: - makeRequest
    func makeRequest<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        //издатель
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        publisher.sink { result in
            switch result {
            case .finished:
                print("finished!")
            case .failure(let error):
                completion(.failure(.error(error)))
            }
        } receiveValue: { data, response in
            let decodeDate = try? JSONDecoder().decode(T.self, from: data)
            
            if decodeDate == nil  {
                guard let httpResponse = response as? HTTPURLResponse else { return }
                
                switch httpResponse.statusCode {
                case 100..<199:
                    completion(.failure(NetworkError.errorWithDescription("Информационная ошибка. Код ошибки: \(httpResponse.statusCode).")))
                case 300..<399:
                    completion(.failure(NetworkError.errorWithDescription("Ошибка перенаправления. Код ошибки: \(httpResponse.statusCode).")))
                case 400..<499:
                    completion(.failure(NetworkError.errorWithDescription("Ошибка клиента. Код ошибки: \(httpResponse.statusCode).")))
                case 500..<599:
                    completion(.failure(NetworkError.errorWithDescription("Ошибка сервера. Код ошибки: \(httpResponse.statusCode).")))
                default:
                    completion(.failure(.errorWithDescription("Нет соединения с интернетом.")))
                }
            } else {
                completion(.success(decodeDate!))
            }
        }.store(in: &cancellable)
    }
}
