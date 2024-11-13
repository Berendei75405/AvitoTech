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
    func fetchEmployees(completion: @escaping (Result<MainModel, Error>) -> Void) {
        guard let url = URL(string: "https://run.mocky.io/v3/f2d9155a-f21d-4ac8-8114-3a83756af259") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        networkService.makeRequest(request: request,
                                   completion: completion)
    }
}
