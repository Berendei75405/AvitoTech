//
//  ViewController.swift
//  AvitoTech
//
//  Created by Novgorodcev on 10/11/2024.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    var viewModel: MainViewModel?
    private var cancellabele = Set<AnyCancellable>()
    
    //MARK: - deinit
    deinit {
        print("MainViewController")
    }
    
    //MARK: - tableView
    private var tableView: UITableView = {
        var table  = UITableView(frame: .zero, style: .plain)
        
        table.backgroundColor = #colorLiteral(red: 0.9719608426, green: 0.9722560048, blue: 0.9813567996, alpha: 1)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        
        //регистрация ячеек
        table.register(EmployeesCell.self, forCellReuseIdentifier: EmployeesCell.identifier)
        
        return table
    }()
    
    //MARK: - tableState
    private var tableState: TableState = .initial {
        didSet {
            switch tableState {
            case .initial:
                print("Таблица инициализированна")
            case .success:
                tableView.reloadData()
                tableView.delegate = self
                tableView.dataSource = self
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.fetchEmployees()
        updateState()
        setupUI()
    }
    
    //MARK: - updateState
    private func updateState() {
        viewModel?.updateTableState.sink(receiveValue: { [unowned self] state in
            self.tableState = state
            print(state)
        }).store(in: &cancellabele)
    }
    
    //MARK: - setupUI
    private func setupUI() {
        //table
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor
                .constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor
                .constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

//MARK: - Extension
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.model?.company.employees.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeesCell.identifier, for: indexPath) as? EmployeesCell else { return UITableViewCell() }
        
        if let model = viewModel?.model?.company.employees {
            cell.config(name: model[indexPath.row].name,
                        phoneNumber: model[indexPath.row].phoneNumber,
                        skills: model[indexPath.row].skills)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    //height cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
