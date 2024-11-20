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
    
    private var centerYConstraint: NSLayoutConstraint!
    
    //MARK: - tableView
    private var tableView: UITableView = {
        var table  = UITableView(frame: .zero, style: .plain)
        
        table.backgroundColor = UIColor(named: "backgroundColor")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        
        //регистрация ячеек
        table.register(EmployeesCell.self, forCellReuseIdentifier: EmployeesCell.identifier)
        
        return table
    }()
    
    //MARK: - refreshControl
    private let refreshControl = UIRefreshControl()
    
    //MARK: - activityView
    private var activityView: UIActivityIndicatorView = {
        var progres = UIActivityIndicatorView(style: .large)
        progres.translatesAutoresizingMaskIntoConstraints = false
        progres.startAnimating()
        progres.color = .black
        
        return progres
    }()
    
    //MARK: - tableState
    private var tableState: TableState = .initial {
        didSet {
            switch tableState {
            case .initial:
                activityView.isHidden = false
            case .success:
                activityView.isHidden = true
                UIView.animate(withDuration: 0.8,
                               delay: 0,
                               options: .curveEaseInOut,
                               animations: {
                    self.centerYConstraint.constant = self.view.frame.height * 2
                    self.view.layoutIfNeeded()
                })
                tableView.delegate = self
                tableView.dataSource = self
                tableView.reloadData()
            case .failure(let error):
                activityView.isHidden = true
                UIView.animate(withDuration: 0.8,
                               delay: 0,
                               options: .curveEaseInOut,
                               animations: {
                    self.centerYConstraint.constant = 0
                    self.view.layoutIfNeeded()
                })
                switch error {
                    case .errorWithDescription(let stringError):
                        errorLabel.text = stringError
                    case .error(let error):
                        errorLabel.text = error.localizedDescription
                }
            }
        }
    }
    
    //MARK: - errorView
    private let errorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.layer.cornerRadius = 15
        view.alpha = 1
        
        return view
    }()
    
    //MARK: - errorLabel
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20)
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        return label
    }()
    
    //MARK: - closeButton
    private let closeButton: UIButton = {
        var but = UIButton()
        but.translatesAutoresizingMaskIntoConstraints = false
        but.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        but.setImage(UIImage(systemName: "xmark"), for: .normal)
        but.tintColor = .black
        but.layer.cornerRadius = 5
        
        return but
    }()

    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        tableState = .initial
        viewModel?.fetchEmployees()
        updateState()
        setupUI()
    }
    
    //MARK: - updateState
    private func updateState() {
        viewModel?.updateTableState.sink(receiveValue: { [unowned self] state in
            self.tableState = state
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
        
        //refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        //errorView
        view.addSubview(errorView)
        centerYConstraint = errorView.centerYAnchor.constraint(
            equalTo: view.centerYAnchor, constant: view.frame.height * 2)
        NSLayoutConstraint.activate([
            errorView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            centerYConstraint,
            errorView.widthAnchor.constraint(
                equalToConstant: view.frame.width - 64),
            errorView.heightAnchor.constraint(
                equalToConstant: view.frame.height/2)
        ])
        
        //errorLabel
        errorView.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(
                equalTo: errorView.topAnchor,
                constant: 32),
            errorLabel.leadingAnchor.constraint(
                equalTo: errorView.leadingAnchor,
                constant: 8),
            errorLabel.trailingAnchor.constraint(
                equalTo: errorView.trailingAnchor,
                constant: -8),
            errorLabel.bottomAnchor.constraint(
                equalTo: errorView.bottomAnchor,
                constant: -32)
        ])
        
        //closeButton
        errorView.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(
                equalTo: errorView.topAnchor,
                constant: 8),
            closeButton.trailingAnchor.constraint(
                equalTo: errorView.trailingAnchor,
                constant: -8),
            closeButton.heightAnchor.constraint(
                equalToConstant: 35),
            closeButton.widthAnchor.constraint(
                equalToConstant: 35)
        ])
        
        //activityView
        view.addSubview(activityView)
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor),
            activityView.heightAnchor.constraint(
                equalToConstant: 100),
            activityView.widthAnchor.constraint(
                equalToConstant: 100)
        ])
        
    }
    
    //MARK: - closeButtonAction
    @objc private func closeButtonAction() {
        self.activityView.isHidden = false
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.centerYConstraint.constant = self.view.frame.height * 2
            self.view.layoutIfNeeded()
        })
        viewModel?.fetchEmployees()
    }
    
    //MARK: - refreshTable
    @objc private func refreshTable() {
        viewModel?.fetchEmployees()
        refreshControl.endRefreshing()
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
