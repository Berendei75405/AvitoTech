//
//  Model.swift
//  AvitoTech
//
//  Created by Novgorodcev on 10/11/2024.
//

import Foundation

//MARK: - MainModel
struct MainModel: Codable {
    var company: Company
}

// MARK: - Company
struct Company: Codable {
    let name: String
    var employees: [Employee]
}

// MARK: - Employee
struct Employee: Codable {
    let name, phoneNumber: String
    let skills: [String]

    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumber = "phone_number"
        case skills
    }
}
