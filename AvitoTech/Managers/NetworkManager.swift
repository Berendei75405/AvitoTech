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
        guard let url = URL(string: "https://run.mocky.io/v3/19c81ec6-05af-4fb4-b0c2-3011a3883ede") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        networkService.makeRequest(request: request,
                                   completion: completion)
    }
}
