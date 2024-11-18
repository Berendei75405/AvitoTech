//
//  ViewModel.swift
//  AvitoTech
//
//  Created by Novgorodcev on 10/11/2024.
//

import Foundation
import Combine

//MARK: - TableState
enum TableState {
    case success, failure(NetworkError), initial
}

protocol MainViewModelProtocol: AnyObject {
    var model: MainModel? {get set}
    var updateTableState: PassthroughSubject<TableState, Never> {get set}
    func fetchEmployees()
}

final class MainViewModel: MainViewModelProtocol {
    private let networkManager = NetworkManager.shared
    var model: MainModel?
    var updateTableState = PassthroughSubject<TableState, Never>()
    
    //MARK: - fetchEmployees
    func fetchEmployees() {
        networkManager.fetchEmployees { [weak self] result in
            switch result {
            case .success(let model):
                self?.model = model
                self?.updateTableState.send(.success)
            case .failure(let error):
                self?.updateTableState.send(.failure(error))
            }
        }
    }
    
}
