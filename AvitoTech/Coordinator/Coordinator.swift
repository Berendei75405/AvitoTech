//
//  Coordinator.swift
//  AvitoTech
//
//  Created by Novgorodcev on 10/11/2024.
//

import UIKit

protocol MainCoordinatorProtocol: AnyObject {
    
}

final class Coordinator: MainCoordinatorProtocol {
    var navigationController: UINavigationController?
    
    init(navCon: UINavigationController) {
        self.navigationController = navCon
    }
    
    //MARK: - createViewController
    func createMainVC() -> UIViewController {
        let view = MainViewController()
        let viewModel = MainViewModel()
        
        view.viewModel = viewModel
        
        return view
    }
    
    //MARK: - initialMainVC
    func initialMainVC() {
        if let navCon = navigationController {
            let view = createMainVC()
            
            navCon.viewControllers = [view]
        }
    }
}
