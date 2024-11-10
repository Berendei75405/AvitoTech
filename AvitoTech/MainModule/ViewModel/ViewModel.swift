//
//  ViewModel.swift
//  AvitoTech
//
//  Created by Novgorodcev on 10/11/2024.
//

import Foundation

protocol MainViewModelProtocol: AnyObject {
    var model: MainModel? {get set}
}

final class MainViewModel: MainViewModelProtocol {
    
    var model: MainModel?
    
}
