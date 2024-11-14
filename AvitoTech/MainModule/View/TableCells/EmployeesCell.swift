//
//  EmployeesCell.swift
//  AvitoTech
//
//  Created by Novgorodcev on 15/11/2024.
//

import UIKit

final class EmployeesCell: UITableViewCell {
    static let identifier = "EmployeesCell"
    
    //MARK: - containerView
    private let containerView: UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20

        return view
    }()
    
    //MARK: - employImageView
    private let employImageView: UIImageView = {
        let image = UIImage(systemName: "person.fill")
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        return imageView
    }()
    
    //MARK: - nameLabel
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Имя:"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    //MARK: - nameInfoLabel
    private let nameInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .italicSystemFont(ofSize: 16)
        
        return label
    }()
    
    //MARK: - phoneLabel
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Телефон:"
        label.font = .boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    //MARK: - phoneNumber
    private let phoneInfoLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .italicSystemFont(ofSize: 16)
        
        return label
    }()
    
    //MARK: - skillsLabel
    private let skillsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Навыки:"
        
        return label
    }()
    
    //MARK: - skillsInfoLabel
    private let skillsInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .italicSystemFont(ofSize: 16)
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = ""
        
        return label
    }()
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    //MARK: - required init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - config
    func config(name: String,
                phoneNumber: String,
                skills: [String]) {
        nameInfoLabel.text = name
        phoneInfoLabel.text = phoneNumber
      
        for element in 0..<skills.count {
            if element != skills.count - 1 {
                //не может быть nil, так как есть дефолтное значение
                skillsInfoLabel.text! += skills[element] + ", "
            } else {
                skillsInfoLabel.text! += skills[element]
            }
        }
    }
    
    //MARK: - setupUI
    private func setupUI() {
        //containerView constraints
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 16),
            containerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16),
            containerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16),
            containerView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -16)
        ])
        
        //employImageView constraints
        containerView.addSubview(employImageView)
        NSLayoutConstraint.activate([
            employImageView.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 8),
            employImageView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: 8),
            employImageView.trailingAnchor.constraint(
                equalTo: containerView.leadingAnchor
                ,constant: 80),
            employImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
        
        //nameLabel constraints
        containerView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: 8),
            nameLabel.leadingAnchor.constraint(
                equalTo: employImageView.trailingAnchor,
                constant: 16)
        ])
        
        //nameInfoLabel constraints
        containerView.addSubview(nameInfoLabel)
        NSLayoutConstraint.activate([
            nameInfoLabel.topAnchor.constraint(
                equalTo: nameLabel.topAnchor),
            nameInfoLabel.leadingAnchor.constraint(
                equalTo: nameLabel.trailingAnchor, constant: 8)
        ])
        
        //phoneLabel constraints
        containerView.addSubview(phoneLabel)
        NSLayoutConstraint.activate([
            phoneLabel.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: 8),
            phoneLabel.leadingAnchor.constraint(
                equalTo: nameLabel.leadingAnchor)
        ])
        
        //phoneInfoLabel
        containerView.addSubview(phoneInfoLabel)
        NSLayoutConstraint.activate([
            phoneInfoLabel.topAnchor.constraint(
                equalTo: phoneLabel.topAnchor),
            phoneInfoLabel.leadingAnchor.constraint(
                equalTo: phoneLabel.trailingAnchor, constant: 8)
        ])
        
        //skillsLabel constraints
        containerView.addSubview(skillsLabel)
        NSLayoutConstraint.activate([
            skillsLabel.topAnchor.constraint(
                equalTo: phoneLabel.bottomAnchor,
                constant: 8),
            skillsLabel.leadingAnchor.constraint(
                equalTo: nameLabel.leadingAnchor)
        ])
        
        //skillsInfoLabel constraints
        containerView.addSubview(skillsInfoLabel)
        NSLayoutConstraint.activate([
            skillsInfoLabel.topAnchor.constraint(
                equalTo: skillsLabel.topAnchor),
            skillsInfoLabel.leadingAnchor.constraint(
                equalTo: skillsLabel.trailingAnchor,
                constant: 8),
            skillsInfoLabel.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -8)
        ])
    }
}
