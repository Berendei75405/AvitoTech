//
//  NetworkManager.swift
//  AvitoTech
//
//  Created by Novgorodcev on 13/11/2024.
//

import Foundation

final class NetworkManager {
    private var networkService = NetworkService.shared
    static let shared = NetworkManager()
    
    private init() {}
    
    //MARK: - fetchEmployees
    func fetchEmployees(completion: @escaping (Result<MainModel, NetworkError>) -> Void) {
        guard let url = URL(string: "https://run.mocky.io/v3/d9f535a6-0c46-4eab-aff7-7d17b237a02d") else { return }
        
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        request.httpMethod = "GET"
        
        networkService.makeRequest(request: request,
                                   completion: completion)
    }
}
